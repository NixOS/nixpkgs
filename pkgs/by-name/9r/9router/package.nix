{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  runCommand,
  nodejs_22,
  python3,
  makeWrapper,
}:

let
  version = "0.5.86";

  src = fetchFromGitHub {
    owner = "decolua";
    repo = "9router";
    tag = "v${version}";
    hash = "sha256-WXob9QYhSWfEi4T65mkkunYyOXjn99laAd1FtElHttQ=";
  };

  # Upstream does not commit package-lock.json files, so they are vendored
  # here. fetchNpmDeps only needs the manifest and lockfile, so a minimal
  # source tree is enough; the FOD output matches the lockfile contents.
  rootNpmDeps = fetchNpmDeps {
    name = "9router-root-npm-deps";
    src = runCommand "9router-root-npm-src" { } ''
      mkdir $out
      cp ${src}/package.json $out/package.json
      cp ${./package-lock.json} $out/package-lock.json
    '';
    hash = "sha256-zm2R0N8oCbu+8wydMI0lOykzgXpgrScOFLKNi6K1rAs=";
  };

  # `cli/` is a separate npm package (published to npm as `9router`) with its
  # own dependency tree - it wraps the built dashboard as the CLI launcher.
  cliNpmDeps = fetchNpmDeps {
    name = "9router-cli-npm-deps";
    src = runCommand "9router-cli-npm-src" { } ''
      mkdir $out
      cp ${src}/cli/package.json $out/package.json
      cp ${./cli-package-lock.json} $out/package-lock.json
    '';
    hash = "sha256-pY3U/EstiuNQrEpCdpOgvbKoo/WaZNBiR49hJAN44Ww=";
  };

  # Reusable shell snippet: point npm at a prefetched fetchNpmDeps cache and
  # force fully-offline installs inside the sandbox.
  npmOfflineEnv = cache: ''
    export npm_config_cache=${cache}
    export npm_config_offline=true
    export npm_config_progress=false
    export npm_config_audit=false
    export npm_config_fund=false
    export npm_config_update_notifier=false
  '';
in

stdenv.mkDerivation {
  pname = "9router";
  inherit version src;

  nativeBuildInputs = [
    nodejs_22
    python3 # node-gyp fallback for any native addon that slips through
    makeWrapper
  ];

  # Next.js telemetry phones home during build; the sandbox has no network.
  env.NEXT_TELEMETRY_DISABLED = "1";

  # The output is JavaScript plus a small shell wrapper - nothing meaningful
  # to strip. Skipping it saves ~15 minutes of fixup on the 65 MB bundle.
  dontStrip = true;

  postPatch = ''
    # Vendor the lockfiles (upstream does not commit them).
    cp ${./package-lock.json} package-lock.json
    cp ${./cli-package-lock.json} cli/package-lock.json

    # next/font/google fetches Inter from fonts.googleapis.com at build time,
    # which the Nix sandbox blocks. Neutralize it here; without the variable,
    # `font-sans` falls back to the system sans stack that globals.css
    # already declares.
    node -e '
      const fs = require("fs");
      const p = "src/app/layout.js";
      let s = fs.readFileSync(p, "utf8");
      s = s.replace(/import \{ Inter \} from "next\/font\/google";\n/, "");
      s = s.replace(/const inter = Inter\(\{[^}]*\}\);/, "const inter = { variable: \"\" };");
      if (/next\/font\/google/.test(s) || /Inter\(\{/.test(s)) {
        throw new Error("next/font/google neutralization failed - layout.js changed?");
      }
      fs.writeFileSync(p, s);
    '
  '';

  buildPhase = ''
    runHook preBuild

    # Keep any stray postinstall/runtime writes inside the sandbox
    # (better-sqlite3, systray warm-ups target $HOME/.9router otherwise).
    export HOME=$TMPDIR

    # Install root (Next.js dashboard) deps from the prefetched cache.
    ${npmOfflineEnv rootNpmDeps}
    npm ci --ignore-scripts
    patchShebangs node_modules

    # Install cli/'s own deps (esbuild, enquirer, ...) from its separately
    # prefetched cache. --ignore-scripts is mandatory here: cli/package.json
    # has a postinstall that spawns real `npm install`s into
    # ~/.9router/runtime and stalls on dead network inside the sandbox.
    (
      cd cli
      ${npmOfflineEnv cliNpmDeps}
      npm ci --ignore-scripts
      patchShebangs node_modules
    )

    # `cli`'s build script (scripts/build-cli.js) drives everything: it runs
    # the root `next build` with NEXT_DIST_DIR=.next-cli-build and workspace
    # tracing, copies the standalone output into cli/app, bundles sql.js and
    # `open`, strips better-sqlite3, and esbuild-bundles the MITM server.
    (cd cli && npm run build)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/9router $out/bin
    cp -r cli/cli.js cli/src cli/hooks cli/app cli/node_modules cli/package.json cli/README.md cli/LICENSE $out/lib/9router/

    # The CLI spawns the standalone server via process.execPath, so the
    # wrapper only needs to put node on cli.js itself.
    makeWrapper ${nodejs_22}/bin/node $out/bin/9router \
      --add-flags "$out/lib/9router/cli.js"

    runHook postInstall
  '';

  meta = {
    description = "Local AI routing gateway with OpenAI-compatible endpoint and web dashboard";
    homepage = "https://github.com/decolua/9router";
    license = lib.licenses.mit;
    mainProgram = "9router";
    maintainers = [ lib.maintainers.levonk ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

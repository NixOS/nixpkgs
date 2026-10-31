{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs_22,
  python3,
  unstableGitUpdater,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    web = buildNpmPackage {
      pname = "busybar-manager";

      version = "0.1.0";

      src = "${finalAttrs.src}/web";

      strictDeps = true;

      __structuredAttrs = true;

      nodejs = nodejs_22;

      npmDepsHash = "sha256-p058o++0KjcWhjW/XG6U/+V77X7UFtT54GnFnxGqtPg=";

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r dist $out

        runHook postInstall
      '';
    };
  in
  {
    pname = "busybar-manager";
    version = "0-unstable-2026-08-28";

    src = fetchFromGitHub {
      owner = "maxswinkels";
      repo = "busybar-manager";
      rev = "70dc7530aa9e14203701f6c460c2aa1cbe68612f";
      hash = "sha256-QMqMrLG17MK5LWdu5tiQmrALt/HQA58PfQaPv9NZdZY=";
    };

    nativeBuildInputs = [ makeWrapper ];

    strictDeps = true;

    __structuredAttrs = true;

    dontBuild = true;

    postPatch = ''
      substituteInPlace server.js \
        --replace-fail \
          'const WEB_DIST = path.join(ROOT, "web", "dist");' \
          "const WEB_DIST = \"$out/share/busybar-manager/web/dist\";" \
        --replace-fail \
          'const APPS_INSTALL_DIR = path.join(ROOT, "apps");' \
          'const APPS_INSTALL_DIR = process.env.BUSYBAR_MANAGER_APPS_DIR || path.join(ROOT, "apps");'
    '';

    installPhase = ''
      runHook preInstall

      # Install the server.js and package.json files.
      install -Dm644 server.js    "$out/share/busybar-manager/server.js"
      install -Dm644 package.json "$out/share/busybar-manager/package.json"

      # Embed the built web dashboard at the path server.js expects.
      mkdir -p "$out/share/busybar-manager/web"
      cp -r "${web}/dist" "$out/share/busybar-manager/web"

      # Wrapper: launch server.js with the bundled Node, point python to the Nix store
      makeWrapper "${lib.getExe nodejs_22}" "$out/bin/busybar-manager" \
        --add-flags "$out/share/busybar-manager/server.js" \
        --set    BUSYBAR_PYTHON          "${lib.getExe python3}"

      runHook postInstall
    '';

    passthru.updateScript = unstableGitUpdater { };

    meta = {
      description = "Run, manage and monitor apps for the BUSY Bar";
      homepage = "https://github.com/maxswinkels/busybar-manager";
      license = lib.licenses.mit;
      maintainers = [ lib.maintainers.joaosreis ];
    };
  }
)

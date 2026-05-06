{
  bash,
  dotenv-cli,
  coreutils,
  lib,
  installShellFiles,
  fetchFromGitHub,
  makeWrapper,
  inter,
  nodejs,
  pnpm_10,
  python3,
  node-gyp,
  removeReferencesTo,
  replaceVars,
  srcOnly,
  stdenv,
}:
let
  pnpm = pnpm_10;
  nodeSources = srcOnly nodejs;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "homarr";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "homarr-labs";
    repo = "homarr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0pdZHTmubcsZivHrH31MVRSEJH6rM0846qmpqwC1dGM=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    pnpmInstallFlags = [
      "--recursive"
    ];
    hash = "sha256-Il5W2iz78k6DKeNvIjLKIczWJARxdV4ic9wLAYJXbqM=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm.configHook
    python3
    node-gyp
  ];

  propagatedBuildInputs = [
    pnpm
    nodejs
  ];

  patches = [
    # nextjs tries to download google fonts from the internet during buildPhase and fails in Nix sandbox.
    # We patch the code to expect a local font from src/app/Inter.ttf that we load from Nixpkgs in preBuild phase.
    ./0001-font-replace-remote-google-font-with-local.patch
    ./0002-ports-allow-variable-ports-for-web-and-websockets.patch
    ./0003-redis-allow-custom-db.patch
    ./0004-nodejs-relax-dep-to-22.17.patch
  ];

  # Adjust buildNpmPackage phases with nextjs quirk workarounds.
  # These are adapted from
  # https://github.com/NixOS/nixpkgs/blob/485125d667747f971cfcd1a1cfb4b2213a700c79/pkgs/servers/homepage-dashboard/default.nix
  #######################3
  preBuild =
    # bash
    ''
      export npm_config_nodedir="${nodeSources}"
      for f in $(find -path '*/node_modules/better-sqlite3' -type d); do
        (cd "$f" && (
        npm run build-release --offline --nodedir="${nodeSources}"
        find build -type f -exec \
          ${lib.getExe removeReferencesTo} \
          -t "${nodeSources}" {} \;
        ))
      done

      # Replace the googleapis.com Inter font with a local copy from nixpkgs
      install -m444 -D "${inter}/share/fonts/truetype/InterVariable.ttf" apps/nextjs/src/app/Inter.ttf
    '';

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -m444 -D  node_modules/better-sqlite3/build/Release/better_sqlite3.node $out/lib/build/better_sqlite3.node

    cp -r apps node_modules package.json packages scripts static-data tooling turbo turbo.json $out/lib

    cp -r apps/nextjs/.next/standalone $out/lib/nextjs
    cp -r apps/nextjs/.next/static $out/lib/nextjs/apps/nextjs/.next/
    cp -r apps/nextjs/public $out/lib/nextjs/apps/nextjs/

    # any call to with-env will fail without .env present
    touch $out/lib/.env

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${lib.getExe bash} $out/bin/homarr-shell \
      --set PATH ${
        lib.makeBinPath [
          pnpm
          nodejs
          dotenv-cli
          coreutils
          bash
        ]
      } \
      --chdir "$out/lib" \
      --set "NODE_ENV" "production" \
      --set "NO_LOGFILES" "true"

    makeWrapper ${lib.getExe pnpm} $out/bin/homarr-migrate \
      --set PATH ${
        lib.makeBinPath [
          pnpm
          nodejs
          dotenv-cli
          coreutils
          bash
        ]
      } \
      --chdir "$out/lib" \
      --add-flags "run db:migration:sqlite:run"

    makeWrapper ${lib.getExe pnpm} $out/bin/homarr-tasks \
      --set PATH ${
        lib.makeBinPath [
          pnpm
          nodejs
        ]
      } \
      --chdir "$out/lib" \
      --add-flags "node apps/tasks/tasks.cjs"

    makeWrapper ${lib.getExe pnpm} $out/bin/homarr-wss \
      --set PATH ${
        lib.makeBinPath [
          pnpm
          nodejs
          dotenv-cli
          coreutils
          bash
        ]
      } \
      --chdir "$out/lib" \
      --add-flags "node apps/websocket/wssServer.cjs"

    makeWrapper ${lib.getExe pnpm} $out/bin/homarr-nextjs \
      --set PATH ${
        lib.makeBinPath [
          pnpm
          nodejs
          dotenv-cli
          coreutils
          bash
        ]
      } \
      --chdir "$out/lib/nextjs" \
      --add-flags "node apps/nextjs/server.js"
  '';

  meta = {
    description = "Modern and easy to use dashboard for your server";
    longDescription = ''
      14+ integrations. 10K+ icons built in. Authentication out of the box. No YAML, drag and drop configuration.
    '';
    homepage = "https://homarr.dev";
    changelog = "https://github.com/ajnart/homarr/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tebriel ];
    mainProgram = "homarr";
    platforms = lib.platforms.all;
  };
})

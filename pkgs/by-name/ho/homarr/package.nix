{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  inter,
  nodejs,
  pnpm,
  python3,
  removeReferencesTo,
  replaceVars,
  srcOnly,
  stdenv,
}:
let
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

  postFixup = ''
    # else it fails to find the python interpreter
    patchShebangs --build $out/bin/taler-helper-sqlite3
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-Il5W2iz78k6DKeNvIjLKIczWJARxdV4ic9wLAYJXbqM=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm.configHook
    python3
  ];

  patches = [
    # nextjs tries to download google fonts from the internet during buildPhase and fails in Nix sandbox.
    # We patch the code to expect a local font from src/app/Inter.ttf that we load from Nixpkgs in preBuild phase.
    ./0001-font-replace-remote-google-font-with-local.patch
    ./0002-ports-allow-variable-ports-for-web-and-websockets.patch
    ./0003-redis-allow-custom-db.patch
  ];

  # Adjust buildNpmPackage phases with nextjs quirk workarounds.
  # These are adapted from
  # https://github.com/NixOS/nixpkgs/blob/485125d667747f971cfcd1a1cfb4b2213a700c79/pkgs/servers/homepage-dashboard/default.nix
  #######################3
  preBuild = ''
    for f in $(find -path '*/node_modules/better-sqlite3' -type d); do
      (cd "$f" && (
      npm run build-release --offline --nodedir="${nodeSources}"
      find build -type f -exec \
        ${lib.getExe removeReferencesTo} \
        -t "${nodeSources}" {} \;
      ))
    done

    install -m444 -D ./node_modules/better-sqlite3/build/Release/better_sqlite3.node ./build/better_sqlite3.node

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
    mkdir -p $out
    cp -r apps build node_modules package.json packages scripts static-data tooling turbo turbo.json $out
    runHook postInstall
  '';

  preFixup = ''
    makeWrapper ${lib.getExe nodejs} $out/bin/homarr \
      --chdir "$out/lib/homarr" \
      --set "NODE_ENV" "production" \
      --set "NO_LOGFILES" "true" \
      --set "TSX_TSCONFIG_PATH" "$out/lib/homarr/tsconfig.json" \
      --append-flags "$out/lib/homarr/node_modules/tsx/dist/cli.mjs" \
      --append-flags "$out/lib/homarr/lib/index.ts"
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

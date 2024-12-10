{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  makeWrapper,
  nodejs,
  fixup-yarn-lock,
  yarn,
}:

stdenv.mkDerivation rec {
  pname = "shepherd";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "NerdWalletOSS";
    repo = "shepherd";
    rev = "v${version}";
    hash = "sha256-LY8Vde4YpGuKnQ5UnSOpsQDY7AOyZRziUrfZb5dRiX4=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-tJXJ8ePr5ArAV+0JcuJsTo/B2PUcgsXfZrSDCpna/9k=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    fixup-yarn-lock
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out/lib/node_modules/@nerdwallet/shepherd"
    cp -r . "$out/lib/node_modules/@nerdwallet/shepherd"

    makeWrapper "${nodejs}/bin/node" "$out/bin/shepherd" \
      --add-flags "$out/lib/node_modules/@nerdwallet/shepherd/lib/cli.js"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/NerdWalletOSS/shepherd/blob/${src.rev}/CHANGELOG.md";
    description = "A utility for applying code changes across many repositories";
    homepage = "https://github.com/NerdWalletOSS/shepherd";
    license = lib.licenses.asl20;
    mainProgram = "shepherd";
    maintainers = with lib.maintainers; [ dbirks ];
    platforms = lib.platforms.all;
  };
}

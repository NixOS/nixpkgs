{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  fixup-yarn-lock,
  yarn,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "lxd-ui";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "lxd-ui";
    tag = version;
    hash = "sha256-HqdaG51W7eUCGUhA+9pYrAWaA6qyK7Fc95CKJvk9GaA=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-O7oEAjmCEmPpsO/rdkZVhUkxhFzhHpPRbmci3yRBA7g=";
  };

  nativeBuildInputs = [
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

    cp -r build/ui/ $out

    runHook postInstall
  '';

  passthru.tests.default = nixosTests.lxd.ui;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web user interface for LXD";
    homepage = "https://github.com/canonical/lxd-ui";
    changelog = "https://github.com/canonical/lxd-ui/releases/tag/${version}";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}

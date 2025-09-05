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
  version = "0.18";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "lxd-ui";
    tag = version;
    hash = "sha256-jlMymRR9bQ7xjXNXnebsq+5l0xox53w6e32NRYztXlM=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-2xC4YjLdzfqRuLrZmO/4GBlTutwMTuti4VSxIPi5BEQ=";
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

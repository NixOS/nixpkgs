{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, nodejs
, fixup-yarn-lock
, yarn
, nixosTests
, git
}:

stdenv.mkDerivation rec {
  pname = "incus-ui";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "lxd-ui";
    rev = "refs/tags/${version}";
    hash = "sha256-DJLkXZpParmEYHbTpl6KFC9l9y5DqzUTrC0pb2dJXI4=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-ckTWE/czzvxbGOF8fsJ3W1sal7+NaHquoSjZSPjkGj4=";
  };

  zabbly = fetchFromGitHub {
    owner = "zabbly";
    repo = "incus";
    rev = "c83023587eb0e3b01c99ba26e63f757ac15c6f9c";
    hash = "sha256-cWKp4ALrae6nEBLvWcOM1T+Aca7eHLwsRguH9aSb10Y=";
  };

  patchPhase = ''
    for p in $zabbly/patches/ui-canonical*patch; do
      echo "applying patch $p"
      git apply -p1 "$p"
    done
    sed -i -f "$zabbly/patches/ui-canonical-renames.sed" src/*/*.ts* src/*/*/*.ts* src/*/*/*/*.ts*
  '';

  nativeBuildInputs = [
    nodejs
    fixup-yarn-lock
    yarn
    git
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

  passthru.tests.default = nixosTests.incus.ui;

  meta = {
    description = "Web user interface for Incus, based on LXD webui";
    homepage = "https://github.com/canonical/lxd-ui";
    license = lib.licenses.gpl3;
    maintainers = lib.teams.lxc.members;
    platforms = lib.platforms.linux;
  };
}

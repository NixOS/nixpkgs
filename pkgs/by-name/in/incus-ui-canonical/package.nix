{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  fixup-yarn-lock,
  yarn,
  nixosTests,
  git,
}:

stdenv.mkDerivation rec {
  pname = "incus-ui-canonical";
  version = "0.14.6";

  src = fetchFromGitHub {
    owner = "zabbly";
    repo = "incus-ui-canonical";
    tag = "incus-${version}";
    hash = "sha256-An2mhIj3D2EdB1Bgnry1l2m6r/GIKTee4anSYNTq8B8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-dkATFNjAPhrPbXhcJ/R4eIpcagKEwBSnRfLwqTPIe6c=";
  };

  zabbly = fetchFromGitHub {
    owner = "zabbly";
    repo = "incus";
    rev = "36714d7c38eb3cc3e4e821c7aed44e066e1e84ca";
    hash = "sha256-H6gjXmwCv3oGXrzn1NENfgO3CWXMnmp94GdJv2Q8n0w=";
  };

  patchPhase = ''
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
    description = "Web user interface for Incus";
    homepage = "https://github.com/zabbly/incus-ui-canonical";
    license = lib.licenses.gpl3;
    maintainers = lib.teams.lxc.members;
    platforms = lib.platforms.linux;
  };
}

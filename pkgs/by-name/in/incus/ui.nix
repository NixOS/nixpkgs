{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, nodejs
, prefetch-yarn-deps
, yarn
, nixosTests
, git
}:

stdenv.mkDerivation rec {
  pname = "incus-ui";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "lxd-ui";
    rev = "refs/tags/${version}";
    hash = "sha256-3Ts6lKyzpMDVATCKD1fFIGTskWzWpQUT9S8cPFnlEOs=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-0pyxwMGGqogEe1w3sail8NUDHtxLQZU9Wg8E6rQNy4o=";
  };

  zabbly = fetchFromGitHub {
    owner = "zabbly";
    repo = "incus";
    rev = "3eabc1960e99e7e515916e3ea7068a412a8c420b";
    hash = "sha256-Kw53Qjurc6WPswB38v6wuRhuuGE34uYxNoAKH4UmTBE=";
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
    prefetch-yarn-deps
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

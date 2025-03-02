{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  fixup-yarn-lock,
  yarn,
  nixosTests,
  git,
  nix-update-script,
}:
let
  # this rarely changes https://github.com/zabbly/incus/blob/daily/patches/ui-canonical-renames.sed
  renamesSed = fetchurl {
    url = "https://raw.githubusercontent.com/zabbly/incus/0fa53811ff1043fd9f28c8b78851b60ca58e1b10/patches/ui-canonical-renames.sed";
    hash = "sha256-f0vd/Xp/kBbZkg6CBM4cZPlwg5WUL/zv3mCAEmugzCE=";
  };
in
stdenv.mkDerivation rec {
  pname = "incus-ui-canonical";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "zabbly";
    repo = "incus-ui-canonical";
    # only use tags prefixed by incus- they are the tested fork versions
    tag = "incus-${version}";
    hash = "sha256-I0t2ShMkc/zYn7I6Vcd9A31ZAscY0D7cWAdF80NwRGg=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-O7oEAjmCEmPpsO/rdkZVhUkxhFzhHpPRbmci3yRBA7g=";
  };

  patchPhase = ''
    find -type f -name "*.ts" -o -name "*.tsx" -o -name "*.scss" | xargs sed -i -f ${renamesSed}
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

  passthru = {
    tests.default = nixosTests.incus.ui;

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "incus-([0-9\\.]+)"
      ];
    };
  };

  meta = {
    description = "Web user interface for Incus";
    homepage = "https://github.com/zabbly/incus-ui-canonical";
    license = lib.licenses.gpl3;
    maintainers = lib.teams.lxc.members;
    platforms = lib.platforms.linux;
  };
}

{
  mkYarnPackage,
  fetchFromGitLab,
  fetchYarnDeps,
  python3,
  pkg-config,
  nodePackages,
  node-gyp,
  vips,
  lib,
  nixosTests,
}:
mkYarnPackage rec {
  inherit (nodePackages) nodejs;
  version = "1.19.4";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "les";
    repo = "gancio";
    rev = "v${version}";
    hash = "sha256-x8s7eBVmHCY3kAjHjACotCncvZq6OBiLPJGF6hvfawE=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-LXeAyxZSZOm6GxRuJb5rlHTlQpYa1fdKSENVjwLY4tU=";
  };

  packageJSON = ./package.json;

  # for pkg-config dependencies:
  yarnPreBuild = ''
    export npm_config_nodedir=${nodePackages.nodejs}
  '';
  # So that sqlite can be found:
  pkgConfig.sqlite3 = {
    nativeBuildInputs = [
      pkg-config
      nodePackages.prebuild-install
      node-gyp
      python3
    ];
    postInstall = ''
      yarn --offline run install
    '';
  };
  # Sharp need to find a vips library
  pkgConfig.sharp = {
    nativeBuildInputs = [
      pkg-config
      python3
      node-gyp
      nodePackages.semver
    ];
    buildInputs = [ vips ];
    postInstall = ''
      yarn --offline run install
    '';
  };

  # build need a writeable node_modules
  configurePhase = ''
    runHook preConfigure

    cp -r $node_modules node_modules
    chmod -R +w node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    yarn --offline build
    yarn --offline pack --filename gancio.tgz
    mkdir -p deps/gancio
    tar -C deps/gancio/ --strip-components=1 -xf gancio.tgz
    rm gancio.tgz

    runHook postBuild
  '';

  passthru = {
    updateScript = ./update.sh;
    tests = {
      inherit (nixosTests) gancio;
    };
  };

  meta = {
    description = "Shared agenda for local communities, running on nodejs";
    homepage = "https://gancio.org/";
    changelog = "https://framagit.org/les/gancio/-/raw/master/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "gancio";
    maintainers = with lib.maintainers; [ jbgi ];
  };
}

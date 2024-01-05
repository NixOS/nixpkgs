{
  mkYarnPackage,
  nodejs,
  fetchFromGitLab,
  fetchYarnDeps,
  python3,
  pkg-config,
  nodePackages,
  vips,
  lib,
  nixosTests,
}:
mkYarnPackage (rec {
  inherit nodejs;
  version = "1.14.1";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "les";
    repo = "gancio";
    rev = "v${version}";
    sha256 = "sha256-RDi92vbB+nxzi+UBdfatiFGRrm1zEujeTYlCa9n/A0g=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "sha256-lsthg/+3052o/gydi1fe2gvqk0h5LrHxf6Q91eV2sRc=";
  };

  packageJSON = ./package.json;

  # for pkg-config dependencies:
  yarnPreBuild = ''
    export npm_config_nodedir=${nodejs}
  '';
  # So that sqlite can be found:
  pkgConfig.sqlite3 = {
    nativeBuildInputs = [
      nodejs.pkgs.node-pre-gyp
      python3
    ];
    postInstall = ''
      export CPPFLAGS="-I${nodejs}/include/node"
      node-pre-gyp install --prefer-offline --build-from-source
      rm -r build-tmp-napi-v6
    '';
  };
  # Sharp need to find a vips library
  pkgConfig.sharp = {
    nativeBuildInputs = [
      pkg-config
      nodejs.pkgs.node-gyp
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

  meta = with lib; {
    description = "A shared agenda for local communities, running on nodejs.";
    homepage = "https://gancio.org/";
    changelog = "https://framagit.org/les/gancio/-/raw/v${version}/CHANGELOG.md?ref_type=tags";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jbgi ];
  };
})

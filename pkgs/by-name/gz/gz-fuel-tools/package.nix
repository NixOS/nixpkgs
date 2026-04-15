{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  pkg-config,
  gz-cmake,
  gz-common,
  gz-msgs,
  gz-tools,
  curl,
  jsoncpp,
  libyaml,
  libzip,
  tinyxml-2,
  python3,
  gtest,
  nix-update-script,
  testers,
}:
let
  version = "11.0.0";
  versionPrefix = "gz-fuel-tools${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-fuel-tools";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-fuel-tools";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-IFnaXBURpN5xTCxFjlcZk9n0sCsUnPBr3NUZrf7Xde0=";
  };

  patches = [
    # Upstream bug: the test YAML config points library_path at src/cmd/cmdfuel11
    # instead of the generated Ruby script in test/lib/ruby/gz/cmdfuel11.
    # Also switch to configure_file + file(GENERATE) so $<CONFIG> is resolved.
    # https://github.com/gazebosim/gz-fuel-tools/pull/501
    ./patches/pr-501.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gz-cmake
  ];

  propagatedBuildInputs = [
    libzip
    curl
    gz-common
    gz-msgs
    gz-tools
    jsoncpp
    libyaml
    tinyxml-2
  ];

  nativeCheckInputs = [
    ctestCheckHook
    python3
  ];

  checkInputs = [ gtest ];

  disabledTests = [
    # Requires network access (unavailable in Nix sandbox).
    "UNIT_FuelClient_TEST"
    "UNIT_Interface_TEST"
    "UNIT_gz_TEST"
    "UNIT_gz_src_TEST"
  ];

  preCheck = ''
    # Some test cases use $HOME.
    export HOME=$(mktemp -d)

    # Point tests at the generated config files in the build tree.
    export GZ_CONFIG_PATH=$PWD/test/conf
  '';

  doCheck = true;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=${versionPrefix}_([\\d\\.]+)" ];
    };
  };

  meta = {
    description = "Client library and command line tools for interacting with Gazebo Fuel servers";
    homepage = "https://github.com/gazebosim/gz-fuel-tools";
    changelog = "https://github.com/gazebosim/gz-fuel-tools/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    pkgConfigModules = [ "gz-fuel-tools" ];
    maintainers = with lib.maintainers; [ taylorhoward92 ];
  };
})

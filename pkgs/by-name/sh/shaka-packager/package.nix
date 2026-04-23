{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  cmake,
  ninja,
  python3,
  nix-update-script,
  abseil-cpp,
  curl,
  gtest,
  nlohmann_json,
  libpng,
  libxml2,
  libwebm,
  mbedtls,
  mimalloc,
  protobuf,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shaka-packager";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "shaka-project";
    repo = "shaka-packager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E493sleVbsuytneK51lxuQnaEzvAEJwAXYmsxcaOXSs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    (python3.withPackages (ps: [
      # As we remove the vendored protobuf in our patch,
      # we must re-add it to the python package used for
      # pssh_box.py.
      ps.protobuf
    ]))
    abseil-cpp
    curl
    gtest
    nlohmann_json
    libpng
    libxml2
    libwebm
    mbedtls
    mimalloc
    protobuf
    zlib
  ];

  cmakeFlags = [
    "-DPACKAGER_VERSION=v${finalAttrs.version}-nixpkgs"
    "-DUSE_SYSTEM_DEPENDENCIES=ON"
    # Targets are selected below in ninjaFlags
    "-DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY=ON"
  ];

  ninjaFlags = [
    "mpd_generator"
    "packager"
    "pssh_box_py"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}-nixpkgs-release";
    };
  };

  meta = {
    description = "Media packaging framework for VOD and Live DASH and HLS applications";
    homepage = "https://shaka-project.github.io/shaka-packager/html/";
    changelog = "https://github.com/shaka-project/shaka-packager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    mainProgram = "packager";
    maintainers = with lib.maintainers; [ niklaskorz ];
    platforms = lib.platforms.all;
  };
})

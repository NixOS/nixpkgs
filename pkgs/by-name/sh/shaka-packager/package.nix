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
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "shaka-project";
    repo = "shaka-packager";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-L10IMsc4dTMa5zwYq612F4J+uKOmEEChY8k/m09wuNE=";
  };

  patches = [
    # By default, the git commit hash and tag are used as version
    # and shaka-packager fails to build if these are not available.
    # This patch makes it possible to pass an external value as version.
    # The value itself is declared further below in `cmakeFlags`.
    ./0001-Allow-external-declaration-of-packager-version.patch
    # Dependencies are vendored as git submodules inside shaka-packager.
    # We want to reuse the dependencies from nixpkgs instead to avoid unnecessary
    # build overhead and to ensure they are up to date.
    # This patch disables the vendored dependencies (by excluding `third-party`),
    # finds them inside the build environment and aliases them so they can be accessed
    # without prefixing namespaces.
    # The last step is necessary to keep the patch size to a minimum, otherwise we'd have
    # to add the namespace identifiers everywhere a dependency is used.
    ./0002-Unvendor-dependencies.patch
    # As nixpkgs ships with a newer version of libcurl than the one vendored in shaka-packager,
    # we have to fix one deprecation.
    # See https://curl.se/libcurl/c/CURLOPT_PUT.html for further information.
    ./0003-Fix-curl-deprecations.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    python3
    abseil-cpp
    curl
    gtest
    nlohmann_json
    libpng
    libxml2
    libwebm
    mbedtls
    mimalloc
    (protobuf.override {
      # must be the same version as for shaka-packager
      inherit abseil-cpp;
    })
    zlib
  ];

  cmakeFlags = [
    "-DPACKAGER_VERSION=v${finalAttrs.version}-nixpkgs"
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

  meta = with lib; {
    description = "Media packaging framework for VOD and Live DASH and HLS applications";
    homepage = "https://shaka-project.github.io/shaka-packager/html/";
    changelog = "https://github.com/shaka-project/shaka-packager/releases/tag/v${finalAttrs.version}";
    license = licenses.bsd3;
    mainProgram = "packager";
    maintainers = with maintainers; [ niklaskorz ];
    platforms = platforms.all;
  };
})

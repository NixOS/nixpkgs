{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwebm";
  version = "1.0.0.32";

  src = fetchFromGitHub {
    owner = "webmproject";
    repo = "libwebm";
    tag = "libwebm-${finalAttrs.version}";
    hash = "sha256-SxDGt7nPVkSxwRF/lMmcch1h+C2Dyh6GZUXoZjnXWb4=";
  };

  patches = [
    # libwebm does not generate cmake exports by default,
    # which are necessary to find and use it as build-dependency
    # in other packages
    ./0001-cmake-exports.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  outputs = [
    "dev"
    "out"
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^libwebm-(.+)$"
    ];
  };

  meta = {
    description = "WebM file parser";
    homepage = "https://www.webmproject.org/code/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ niklaskorz ];
    platforms = lib.platforms.all;
  };
})

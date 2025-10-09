{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libebml,
  nix-update-script,
  pkg-config,
  testers,
  validatePkgConfig,
  libmatroska,
}:

stdenv.mkDerivation rec {
  pname = "libmatroska";
  version = "1.7.1";

  outputs = [
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "Matroska-Org";
    repo = "libmatroska";
    rev = "release-${version}";
    hash = "sha256-hfu3Q1lIyMlWFWUM2Pu70Hie0rlQmua7Kq8kSIWnfHE=";
  };

  patches = [
    (fetchpatch {
      name = "libmatroska-fix-cmake-4.patch";
      url = "https://github.com/Matroska-Org/libmatroska/commit/dc80e194e93e6f0e25c8ad3e015d83aca2a99e10.patch";
      hash = "sha256-2dKRJ6z5rOrLJ5agvXQ6k8TPi5rTMA3H1wCO2F5tBbc=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [ libebml ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=YES" ];

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules { package = libmatroska; };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release-(.*)"
      ];
    };
  };

  meta = {
    description = "Library to parse Matroska files";
    homepage = "https://matroska.org/";
    changelog = "https://github.com/Matroska-Org/libmatroska/blob/${src.rev}/NEWS.md";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "libmatroska" ];
  };
}

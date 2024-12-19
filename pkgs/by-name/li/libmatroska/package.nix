{
  lib,
  stdenv,
  fetchFromGitHub,
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

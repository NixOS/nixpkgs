{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libebml,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libmatroska";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "Matroska-Org";
    repo = "libmatroska";
    rev = "release-${version}";
    hash = "sha256-hfu3Q1lIyMlWFWUM2Pu70Hie0rlQmua7Kq8kSIWnfHE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libebml ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
    "-DCMAKE_INSTALL_PREFIX="
  ];

  meta = {
    description = "Library to parse Matroska files";
    homepage = "https://matroska.org/";
    changelog = "https://github.com/Matroska-Org/libmatroska/blob/${src.rev}/NEWS.md";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.unix;
  };
}

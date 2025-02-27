{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "elfio";
  version = "3.12";

  src = fetchFromGitHub {
    owner = "serge1";
    repo = "elfio";
    rev = "Release_${version}";
    sha256 = "sha256-tDRBscs2L/3gYgLQvb1+8nNxqkr8v1xBkeDXuOqShX4=";
  };

  nativeBuildInputs = [ cmake ];

  nativeCheckInputs = [ boost ];

  cmakeFlags = [ "-DELFIO_BUILD_TESTS=ON" ];

  doCheck = true;

  meta = with lib; {
    description = "Header-only C++ library for reading and generating files in the ELF binary format";
    homepage = "https://github.com/serge1/ELFIO";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ prusnak ];
  };
}

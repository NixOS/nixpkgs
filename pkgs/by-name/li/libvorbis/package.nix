{
  lib,
  stdenv,
  fetchurl,
  libogg,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libvorbis";
  version = "1.3.7";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/vorbis/${pname}-${version}.tar.xz";
    sha256 = "0jwmf87x5sdis64rbv0l87mdpah1rbilkkxszipbzg128f9w8g5k";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ libogg ];

  doCheck = true;

  # strip -mno-ieee-fp flag from configure and configure.ac when using
  # clang as the flag is not recognized by the compiler
  preConfigure = lib.optionalString (stdenv.cc.isClang or false) ''
    sed s/\-mno\-ieee\-fp// -i {configure,configure.ac}
  '';

  meta = with lib; {
    description = "Vorbis audio compression reference implementation";
    homepage = "https://xiph.org/vorbis/";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}

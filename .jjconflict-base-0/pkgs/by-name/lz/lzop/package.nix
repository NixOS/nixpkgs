{
  lib,
  stdenv,
  fetchurl,
  lzo,
}:

stdenv.mkDerivation rec {
  pname = "lzop";
  version = "1.04";

  src = fetchurl {
    url = "https://www.lzop.org/download/lzop-${version}.tar.gz";
    sha256 = "0h9gb8q7y54m9mvy3jvsmxf21yx8fc3ylzh418hgbbv0i8mbcwky";
  };

  buildInputs = [ lzo ];

  meta = with lib; {
    homepage = "http://www.lzop.org";
    description = "Fast file compressor";
    maintainers = [ ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "lzop";
  };
}

{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libdsk";
  version = "1.5.22";

  src = fetchurl {
    url = "https://www.seasip.info/Unix/LibDsk/${pname}-${version}.tar.gz";
    sha256 = "sha256-gQ+AC8x2ZfTBs14ZquyzXzcptxKtHYBxBQWbS9sc8Ek=";
  };

  meta = with lib; {
    description = "Library for accessing discs and disc image files";
    homepage = "http://www.seasip.info/Unix/LibDsk/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}

{ stdenv, mkFranzDerivation, fetchurl }:

mkFranzDerivation rec {
  pname = "franz";
  name = "Franz";
  version = "5.4.1";
  src = fetchurl {
    url = "https://github.com/meetfranz/franz/releases/download/v${version}/franz_${version}_amd64.deb";
    sha256 = "1g1z5zjm9l081hpqslfc4h7pqh4k76ccmlz71r21204wy630mw6h";
  };
  meta = with stdenv.lib; {
    description = "A free messaging app that combines chat & messaging services into one application";
    homepage = "https://meetfranz.com";
    license = licenses.free;
    maintainers = [ maintainers.davidtwco ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}

{ stdenv, mkFranzDerivation, fetchurl }:

mkFranzDerivation rec {
  pname = "franz";
  name = "Franz";
  version = "5.5.0";
  src = fetchurl {
    url = "https://github.com/meetfranz/franz/releases/download/v${version}/franz_${version}_amd64.deb";
    sha256 = "0kgfjai0pz0gpbxsmn3hbha7zr2kax0s1j3ygcsy4kzghla990wm";
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

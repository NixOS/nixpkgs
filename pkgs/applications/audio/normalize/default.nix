{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "normalize-${version}";
  version = "0.7.7";

  src = fetchurl {
    url = "mirror://savannah/normalize/normalize-0.7.7.tar.gz";
    sha256 = "1n5khss10vjjp6w69q9qcl4kqfkd0pr555lgqghrchn6rjms4mb0";
  };

  meta = with stdenv.lib; {
    homepage = http://normalize.nongnu.org/;
    description = "Audio file normalizer";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}

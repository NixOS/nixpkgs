{
  lib,
  stdenv,
  fetchurl,
  libmad,
}:

stdenv.mkDerivation rec {
  pname = "normalize";
  version = "0.7.7";

  src = fetchurl {
    url = "mirror://savannah/normalize/${pname}-${version}.tar.gz";
    sha256 = "1n5khss10vjjp6w69q9qcl4kqfkd0pr555lgqghrchn6rjms4mb0";
  };

  buildInputs = [ libmad ];

  meta = with lib; {
    homepage = "https://www.nongnu.org/normalize/";
    description = "Audio file normalizer";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}

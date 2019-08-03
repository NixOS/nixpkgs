{ stdenv, fetchFromGitHub, cmake, libosmium, protozero, boost, bzip2, zlib, expat }:

stdenv.mkDerivation rec {
  name = "osmium-tool-${version}";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "osmium-tool";
    rev = "v${version}";
    sha256 = "1balhz78nva0agmbp8n9vg8fhmdssnd9fjxj20bpw7b45mxhjc20";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libosmium protozero boost bzip2 zlib expat ];

  meta = with stdenv.lib; {
    description = "Multipurpose command line tool for working with OpenStreetMap data based on the Osmium library";
    homepage = "https://osmcode.org/osmium-tool/";
    license = with licenses; [ gpl3 mit bsd3 ];
    maintainers = with maintainers; [ das-g ];
  };
}

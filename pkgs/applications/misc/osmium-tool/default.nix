{ stdenv, fetchFromGitHub, cmake, libosmium, protozero, boost, bzip2, zlib, expat }:

stdenv.mkDerivation rec {
  pname = "osmium-tool";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "osmium-tool";
    rev = "v${version}";
    sha256 = "13142hj8gfgj6w51a62hjzfmzic90xgrnnlnb70hpdqjy86bxv7j";
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

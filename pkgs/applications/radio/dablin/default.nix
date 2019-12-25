{ stdenv, fetchFromGitHub, cmake, pkgconfig
, mpg123, SDL2, gnome3, faad2, pcre
} :

stdenv.mkDerivation rec {
  pname = "dablin";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "Opendigitalradio";
    repo = "dablin";
    rev = version;
    sha256 = "0d514ixz062xyyh4k3laxwhn3k3a1l4jq4w7rxf8x46d3743zrf7";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ faad2 mpg123 SDL2 gnome3.gtkmm pcre ];

  meta = with stdenv.lib; {
    description = "Play DAB/DAB+ from ETI-NI aligned stream";
    homepage = https://github.com/Opendigitalradio/dablin;
    license = with licenses; [ gpl3 lgpl21 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}


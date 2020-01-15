{ stdenv, fetchFromGitHub, cmake, pkgconfig
, mpg123, SDL2, gnome3, faad2, pcre
} :

stdenv.mkDerivation rec {
  pname = "dablin";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "Opendigitalradio";
    repo = "dablin";
    rev = version;
    sha256 = "04ir7yg7psnnb48s1qfppvvx6lak4s8f6fqdg721y2kd9129jm82";
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


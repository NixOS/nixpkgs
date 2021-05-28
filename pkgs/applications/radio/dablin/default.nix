{ stdenv, fetchFromGitHub, cmake, pkgconfig
, mpg123, SDL2, gnome3, faad2, pcre
} :

stdenv.mkDerivation rec {
  pname = "dablin";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "Opendigitalradio";
    repo = "dablin";
    rev = version;
    sha256 = "0143jnhwwh4din6mlrkbm8m2wm8vnrlk0yk9r5qcvj70r2314bgq";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ faad2 mpg123 SDL2 gnome3.gtkmm pcre ];

  meta = with stdenv.lib; {
    description = "Play DAB/DAB+ from ETI-NI aligned stream";
    homepage = "https://github.com/Opendigitalradio/dablin";
    license = with licenses; [ gpl3 lgpl21 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}


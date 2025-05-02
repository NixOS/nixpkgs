{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, mpg123, SDL2, gtkmm3, faad2, pcre
} :

stdenv.mkDerivation rec {
  pname = "dablin";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "Opendigitalradio";
    repo = "dablin";
    rev = version;
    sha256 = "sha256-1rjL0dSEgF7FF72KiT6Tyj7/wbRc24LzyzmM1IGdglc=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ faad2 mpg123 SDL2 gtkmm3 pcre ];

  meta = with lib; {
    description = "Play DAB/DAB+ from ETI-NI aligned stream";
    homepage = "https://github.com/Opendigitalradio/dablin";
    license = with licenses; [ gpl3 lgpl21 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}


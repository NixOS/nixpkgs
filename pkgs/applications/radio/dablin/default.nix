{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, mpg123, SDL2, gtkmm3, faad2, pcre
} :

stdenv.mkDerivation rec {
  pname = "dablin";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "Opendigitalradio";
    repo = "dablin";
    rev = version;
    sha256 = "sha256-tmmOk7nOkuSCjPNHiwAqP5yf1r8+fsCeDGCxhZUImD4=";
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


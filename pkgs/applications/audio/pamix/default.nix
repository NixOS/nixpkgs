{ lib, stdenv, fetchFromGitHub
, pkg-config, cmake
, libpulseaudio, ncurses }:

stdenv.mkDerivation rec {
  pname = "pamix";
  version = "1.6";

  src = fetchFromGitHub {
    owner  = "patroclos";
    repo   = "pamix";
    rev    = version;
    sha256 = "1d44ggnwkf2gff62959pj45v3a2k091q8v154wc5pmzamam458wp";
  };

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace "/etc" "$out/etc/xdg"
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libpulseaudio ncurses ];

  meta = with lib; {
    description = "Pulseaudio terminal mixer";
    homepage    = "https://github.com/patroclos/PAmix";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };
}

{ stdenv, fetchFromGitHub, cmake, pkgconfig, makeWrapper
, SDL2, alsaLib, libjack2, lhasa, perl, rtmidi, zlib, zziplib }:

stdenv.mkDerivation rec {
  version = "1.02.00";
  name = "milkytracker-${version}";

  src = fetchFromGitHub {
    owner  = "milkytracker";
    repo   = "MilkyTracker";
    rev    = "v${version}";
    sha256 = "05a6d7l98k9i82dwrgi855dnccm3f2lkb144gi244vhk1156n0ca";
  };

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  buildInputs = [ SDL2 alsaLib libjack2 lhasa perl rtmidi zlib zziplib ];

  meta = with stdenv.lib; {
    description = "Music tracker application, similar to Fasttracker II";
    homepage = http://milkytracker.org;
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ zoomulator ];
  };
}

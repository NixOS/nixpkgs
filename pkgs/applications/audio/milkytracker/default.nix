{ stdenv, fetchFromGitHub, cmake, pkgconfig, makeWrapper
, SDL2, alsaLib, libjack2, lhasa, perl, rtmidi, zlib, zziplib }:

stdenv.mkDerivation rec {
  version = "1.02.00";
  pname = "milkytracker";

  src = fetchFromGitHub {
    owner  = "milkytracker";
    repo   = "MilkyTracker";
    rev    = "v${version}";
    sha256 = "05a6d7l98k9i82dwrgi855dnccm3f2lkb144gi244vhk1156n0ca";
  };

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  buildInputs = [ SDL2 alsaLib libjack2 lhasa perl rtmidi zlib zziplib ];

  # Somehow this does not get set automatically
  cmakeFlags = [ "-DSDL2MAIN_LIBRARY=${SDL2}/lib/libSDL2.so" ];

  postInstall = ''
    install -Dm644 $src/resources/milkytracker.desktop $out/share/applications/milkytracker.desktop
    install -Dm644 $src/resources/pictures/carton.png $out/share/pixmaps/milkytracker.png
    install -Dm644 $src/resources/milkytracker.appdata $out/share/appdata/milkytracker.appdata.xml
  '';

  meta = with stdenv.lib; {
    description = "Music tracker application, similar to Fasttracker II";
    homepage = "http://milkytracker.org";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ zoomulator ];
  };
}

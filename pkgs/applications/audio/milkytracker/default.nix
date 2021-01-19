{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, makeWrapper
, SDL2, alsaLib, libjack2, lhasa, perl, rtmidi, zlib, zziplib }:

stdenv.mkDerivation rec {
  version = "1.03.00";
  pname = "milkytracker";

  src = fetchFromGitHub {
    owner  = "milkytracker";
    repo   = "MilkyTracker";
    rev    = "v${version}";
    sha256 = "025fj34gq2kmkpwcswcyx7wdxb89vm944dh685zi4bxx0hz16vvk";
  };

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];

  buildInputs = [ SDL2 alsaLib libjack2 lhasa perl rtmidi zlib zziplib ];

  # Somehow this does not get set automatically
  cmakeFlags = [ "-DSDL2MAIN_LIBRARY=${SDL2}/lib/libSDL2.so" ];

  postInstall = ''
    install -Dm644 $src/resources/milkytracker.desktop $out/share/applications/milkytracker.desktop
    install -Dm644 $src/resources/pictures/carton.png $out/share/pixmaps/milkytracker.png
    install -Dm644 $src/resources/milkytracker.appdata $out/share/appdata/milkytracker.appdata.xml
  '';

  meta = with lib; {
    description = "Music tracker application, similar to Fasttracker II";
    homepage = "http://milkytracker.org";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ zoomulator ];
  };
}

{ stdenv, mkDerivation, fetchFromGitHub, cmake, qtbase, alsaLib, makeDesktopItem, libjack2 }:

let
  desktopItem = makeDesktopItem rec {
    name = "Munt";
    exec = "mt32emu-qt";
    desktopName = name;
    genericName = "Munt synthesiser";
    categories = "Audio;AudioVideo;";
  };
in mkDerivation rec {
  version = "2.4.1";
  pname = "munt";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = with stdenv.lib.versions; "libmt32emu_${major version}_${minor version}_${patch version}";
    sha256 = "0bszhkbz24hhx32f973l6h5lkyn4lxhqrckiwmv765d1sba8n5bk";
  };

  postInstall = ''
    ln -s ${desktopItem}/share/applications $out/share
  '';

  dontFixCmake = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase alsaLib libjack2 ];

  meta = with stdenv.lib; {
    description = "Multi-platform software synthesiser emulating Roland MT-32, CM-32L, CM-64 and LAPC-I devices";
    homepage = "http://munt.sourceforge.net/";
    license = with licenses; [ lgpl21 gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}

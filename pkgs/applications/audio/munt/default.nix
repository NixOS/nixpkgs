{ stdenv, mkDerivation, fetchFromGitHub, cmake, qtbase, alsaLib, makeDesktopItem }:

let
  desktopItem = makeDesktopItem rec {
    name = "Munt";
    exec = "mt32emu-qt";
    desktopName = name;
    genericName = "Munt synthesiser";
    categories = "Audio;AudioVideo;";
  };
in mkDerivation rec {
  version = "2.4.0";
  pname = "munt";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = with stdenv.lib.versions; "libmt32emu_${major version}_${minor version}_${patch version}";
    sha256 = "0521i7js5imlsxj6n7181w5szfjikam0k4vq1d2ilkqgcwrkg6ln";
  };

  postInstall = ''
    ln -s ${desktopItem}/share/applications $out/share
  '';

  dontFixCmake = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase alsaLib ];

  meta = with stdenv.lib; {
    description = "Multi-platform software synthesiser emulating Roland MT-32, CM-32L, CM-64 and LAPC-I devices";
    homepage = "http://munt.sourceforge.net/";
    license = with licenses; [ lgpl21 gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}

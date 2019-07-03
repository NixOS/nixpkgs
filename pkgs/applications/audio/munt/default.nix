{ stdenv, fetchFromGitHub, cmake, qtbase, alsaLib, makeDesktopItem }:

let
  desktopItem = makeDesktopItem rec {
    name = "Munt";
    exec = "mt32emu-qt";
    desktopName = name;
    genericName = "Munt synthesiser";
    categories = "Audio;AudioVideo;";
  };
in stdenv.mkDerivation rec {
  version = "2.3.0";
  pname = "munt";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = with stdenv.lib.versions; "${pname}_${major version}_${minor version}_${patch version}";
    sha256 = "0fjhshs4w942rlfksalalqshflbq83pyz1z0hcq53falh9v54cyw";
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
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}

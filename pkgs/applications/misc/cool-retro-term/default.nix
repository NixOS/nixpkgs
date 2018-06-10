{ stdenv, fetchFromGitHub, qtbase, qtquick1, qmltermwidget,
qtquickcontrols, qtgraphicaleffects, qmake }:

stdenv.mkDerivation rec {
  version = "1.0.1";
  name = "cool-retro-term-${version}";

  src = fetchFromGitHub {
    owner = "Swordfish90";
    repo = "cool-retro-term";
    rev = version;
    sha256 = "1ah54crqv13xsg9cvlwmgyhz90xjjy3vy8pbn9i0vc0ljmpgkqd5";
  };

  patchPhase = ''
    sed -i -e '/qmltermwidget/d' cool-retro-term.pro
  '';

  buildInputs = [ qtbase qtquick1 qmltermwidget qtquickcontrols qtgraphicaleffects ];
  nativeBuildInputs = [ qmake ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  preFixup = ''
    mv $out/usr/share $out/share
    mv $out/usr/bin $out/bin
    rmdir $out/usr
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Terminal emulator which mimics the old cathode display";
    longDescription = ''
      cool-retro-term is a terminal emulator which tries to mimic the look and
      feel of the old cathode tube screens. It has been designed to be
      eye-candy, customizable, and reasonably lightweight.
    '';
    homepage = https://github.com/Swordifish90/cool-retro-term;
    license = with stdenv.lib.licenses; [ gpl2 gpl3 ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ skeidel ];
  };
}

{ stdenv, fetchFromGitHub, qtbase, qtquick1, qmltermwidget
, qtquickcontrols, qtgraphicaleffects, qmake }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "cool-retro-term-${version}";

  src = fetchFromGitHub {
    owner = "Swordfish90";
    repo = "cool-retro-term";
    rev = version;
    sha256 = "0gmigjpc19q7l94q4wzbrxh7cdb6zk3zscaijzwsz9364wsgzb47";
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
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    ln -s $out/bin/cool-retro-term.app/Contents/MacOS/cool-retro-term $out/bin/cool-retro-term
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Terminal emulator which mimics the old cathode display";
    longDescription = ''
      cool-retro-term is a terminal emulator which tries to mimic the look and
      feel of the old cathode tube screens. It has been designed to be
      eye-candy, customizable, and reasonably lightweight.
    '';
    homepage = https://github.com/Swordfish90/cool-retro-term;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ skeidel ];
  };
}

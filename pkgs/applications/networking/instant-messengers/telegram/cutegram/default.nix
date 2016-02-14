{ stdenv, fetchFromGitHub
, qtbase, qtquick1, qtmultimedia, qtquickcontrols, qtgraphicaleffects, makeQtWrapper
, telegram-qml, libqtelegram-aseman-edition }:

stdenv.mkDerivation rec {
  name = "cutegram-${version}";
  version = "2.7.0-stable";

  src = fetchFromGitHub {
    owner = "Aseman-Land";
    repo = "Cutegram";
    rev = "v${version}";
    sha256 = "0qhy30gb8zdrphz1b7zcnv8hmm5fd5qwlvrg7wpsh3hk5niz3zxk";
  };
  # TODO appindicator, for system tray plugin
  buildInputs = [ qtbase qtquick1 qtmultimedia qtquickcontrols qtgraphicaleffects telegram-qml libqtelegram-aseman-edition ];
  nativeBuildInputs = [ makeQtWrapper ];
  enableParallelBuild = true;

  fixupPhase = "wrapQtProgram $out/bin/cutegram";

  configurePhase = "qmake -r PREFIX=$out";

  meta = with stdenv.lib; {
    description = "Telegram client forked from sigram";
    homepage = "http://aseman.co/en/products/cutegram/";
    license = licenses.gpl3;
    maintainers = [ maintainers.profpatsch ];
  };

}

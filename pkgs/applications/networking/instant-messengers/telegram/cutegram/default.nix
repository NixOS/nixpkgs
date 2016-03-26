{ stdenv, fetchgit
, qtbase, qtmultimedia, qtquick1, qtquickcontrols
, qtimageformats, qtgraphicaleffects
, telegram-qml, libqtelegram-aseman-edition
, gst_plugins_base, gst_plugins_good, gst_plugins_bad, gst_plugins_ugly
, makeQtWrapper }:

stdenv.mkDerivation rec {
  name = "cutegram-${meta.version}";

  src = fetchgit {
    url = "https://github.com/Aseman-Land/Cutegram.git";
    rev = "1dbe2792fb5a1760339379907f906e236c09db84";
    sha256 = "080153bpa92jpi0zdrfajrn0yqy3jp8m4704sirbz46dv7471rzl";
  };

  buildInputs =
  [ qtbase qtmultimedia qtquick1 qtquickcontrols
    qtimageformats qtgraphicaleffects
    telegram-qml libqtelegram-aseman-edition 
    gst_plugins_base gst_plugins_good gst_plugins_bad gst_plugins_ugly ];
  nativeBuildInputs = [ makeQtWrapper ];
  enableParallelBuilding = true;

  configurePhase = "qmake -r PREFIX=$out";

  fixupPhase = "wrapQtProgram $out/bin/cutegram";

  meta = with stdenv.lib; {
    version = "2.7.1";
    description = "Telegram client forked from sigram";
    homepage = "http://aseman.co/en/products/cutegram/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ profpatsch AndersonTorres ];
    platforms = platforms.linux;
  };
}
#TODO: appindicator, for system tray plugin (by @profpatsch)

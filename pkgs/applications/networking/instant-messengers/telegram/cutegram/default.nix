{ stdenv, fetchgit
, qtbase, qtmultimedia, qtquick1, qtquickcontrols
, qtimageformats, qtgraphicaleffects
, telegram-qml, libqtelegram-aseman-edition
, gst_all_1
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
  ] ++ (with gst_all_1; [ gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly ]);

  nativeBuildInputs = [ makeQtWrapper ];

  enableParallelBuilding = true;

  configurePhase = "qmake -r PREFIX=$out";

  fixupPhase = ''
    wrapQtProgram $out/bin/cutegram \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

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

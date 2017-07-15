{ stdenv, fetchFromGitHub
, qtbase, qtmultimedia, qtquick1, qtquickcontrols
, qtimageformats, qtgraphicaleffects, qtwebkit
, telegram-qml, libqtelegram-aseman-edition
, gst_all_1
, makeWrapper, qmake }:

stdenv.mkDerivation rec {
  name = "cutegram-${meta.version}";

  src = fetchFromGitHub {
    owner = "Aseman-Land";
    repo = "Cutegram";
    rev = "1dbe2792fb5a1760339379907f906e236c09db84";
    sha256 = "1if10jhq7fcz69sg0lsa26wq70vv4hv871rrxn233s66qb35jjn1";
  };

  buildInputs =
  [ qtbase qtmultimedia qtquick1 qtquickcontrols
    qtimageformats qtgraphicaleffects qtwebkit
    telegram-qml libqtelegram-aseman-edition
  ] ++ (with gst_all_1; [ gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly ]);


  enableParallelBuilding = true;
  nativeBuildInputs = [ makeWrapper qmake ];

  fixupPhase = ''
    wrapProgram $out/bin/cutegram \
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

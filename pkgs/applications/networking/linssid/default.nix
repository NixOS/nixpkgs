{
  lib,
  stdenv,
  fetchurl,
  qtbase,
  qtsvg,
  qmake,
  pkg-config,
  boost,
  wirelesstools,
  iw,
  qwt6_1,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "linssid";
  version = "3.6";

  src = fetchurl {
    url = "mirror://sourceforge/project/linssid/LinSSID_${version}/linssid_${version}.orig.tar.gz";
    sha256 = "sha256-VzAe6T9wjyUSMWZov05xhQLzfyGl6Tto/GBKkDLj5Jw=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    qtsvg
    boost
    qwt6_1
  ];

  postPatch = ''
    sed -e "s|/usr/include/qt5.*$|${qwt6_1}/include|" \
        -e "s|/usr/include/qwt.*$||" \
        -e "s|/usr/lib/libqwt.*$|-lqwt|" \
        -i linssid-app/linssid-app.pro
    sed -e "s|/usr/include/|/nonexistent/|g" -i linssid-app/*.pro
    sed -e "s|/usr|$out|g" \
        -i linssid-app/{linssid-app.pro,linssid.desktop,com.warsev.pkexec.linssid.policy,linssid-pkexec}
    sed -e "s|\.\./\.\./\.\./\.\./usr|$out|g" -i linssid-app/*.ui
  '';

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        wirelesstools
        iw
      ]
    }"
  ];

  meta = {
    description = "Graphical wireless scanning for Linux";
    homepage = "https://sourceforge.net/projects/linssid/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.bjornfor ];
    mainProgram = "linssid";
  };
}

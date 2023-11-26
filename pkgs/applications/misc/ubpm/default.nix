{ stdenv, lib, fetchFromGitea, qmake, qttools, qtbase, qtserialport
, qtconnectivity, qtcharts, wrapQtAppsHook }:

stdenv.mkDerivation (finalAttrs: {
  pname = "ubpm";
  version = "1.7.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "LazyT";
    repo = "ubpm";
    rev = finalAttrs.version;
    hash = "sha256-6lvDSU0ssfs71xrac6R6qlmE0QyVcAMTUf0xmJPVzhY=";
  };

  postPatch = ''
    substituteInPlace sources/mainapp/mainapp.pro \
      --replace 'INSTALLDIR = /tmp/ubpm.AppDir' "INSTALLDIR = $out" \
      --replace '/usr/bin' '/bin' \
      --replace 'INSTALLS += target translations themes devices help lin' 'INSTALLS += target translations themes devices help'
  '';

  preConfigure = ''
    cd ./sources/
  '';

  postInstall = ''
    install -Dm644 ../package/lin/ubpm.desktop -t $out/share/applications/
    install -Dm644 ../package/lin/de.lazyt.ubpm.appdata.xml -t $out/share/metainfo/
    install -Dm644 ../sources/mainapp/res/ico/app.png $out/share/icons/hicolor/256x256/apps/ubpm.png
  '';

  postFixup = ''
    wrapQtApp $out/bin/ubpm
  '';

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];

  # *.so plugins are being wrapped automatically which breaks them
  dontWrapQtApps = true;

  buildInputs = [ qtbase qtserialport qtconnectivity qtcharts ];

  meta = with lib; {
    homepage = "https://codeberg.org/LazyT/ubpm";
    description = "Universal Blood Pressure Manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kurnevsky ];
  };
})

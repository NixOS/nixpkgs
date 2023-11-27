{ stdenv, lib, fetchFromGitLab, qcustomplot, qt5, libopus, eigen, portaudio
, rtaudio, hidapi, udev, pulseaudio }:
stdenv.mkDerivation rec {
  pname = "wfview";
  version = "1.64";
  src = fetchFromGitLab {
    owner = "eliggett";
    repo = "wfview";
    rev = "v${version}";
    sha256 = "QdrCji+gktrWfJKf9+yPkmdzfXOMIh4lwG2JA8WVUT8=";
  };
  patches = [ ./remove-syscalls.patch ];
  nativeBuildInputs = [ qt5.qmake qt5.wrapQtAppsHook ];
  buildInputs = [
    qcustomplot
    qt5.qtserialport
    qt5.qtmultimedia
    qt5.qtgamepad
    libopus
    eigen
    portaudio
    rtaudio
    hidapi
    udev
    pulseaudio
  ];
  preConfigure = ''
    # wfview requires building from a subdirectory due to
    # use of relative paths
    mkdir -p build;
    cd build;
  '';
  postInstall = ''
    mkdir -p $out/usr/share/applications;
    mkdir -p $out/usr/share/icons/hicolor/256x256/apps;
    mkdir -p $out/usr/share/metainfo;
    mkdir -p $out/usr/share/wfview/stylesheets;
    cp $src/resources/wfview.desktop $out/usr/share/applications;
    cp $src/resources/wfview.png $out/usr/share/icons/hicolor/256x256/apps;
    cp -r $src/qdarkstyle $out/usr/share/wfview/stylesheets;
  '';
  qmakeFlags = [ "../wfview.pro" ];
  meta = with lib; {
    homepage = "https://wfview.org/";
    description =
      "A program that allows many modern Icom ham radio transceivers to be controlled via a computer";
    license = licenses.gpl3;

    longDescription = ''
      wfview is a program that allows many modern Icom ham radio transceivers
       (such as the IC-7300, IC-9700, IC-7610, IC-R8600, the IC-705, and many others)
       to be controlled via a computer. wfview shows the gorgeous spectrum display on
       whatever display is connected, including projectors, touch screens, and TVs.
       wfview allows for full radio control from a computer keyboard and basic control
       from a numeric keypad. wfview can run on hardware ranging from the $35 Raspberry
       Pi to laptops to desktops. wfview runs on recent versions of Linux, macOS,
       and Windows. wfview supports rig control over ethernet/wifi as well as over
       the traditional USB serial CIV bus. wfview also allows older radios to be
       accessed over the internet, for full control and low-latency audio streaming.
    '';

    platforms = platforms.linux;
    maintainers = with maintainers; [ jake-arkinstall ];
  };
}


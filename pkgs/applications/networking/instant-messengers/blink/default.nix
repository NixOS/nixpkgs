{ lib, python3, libvncserver, xorg, makeDesktopItem, copyDesktopItems
, mkDerivationWith, fetchdarcs, callPackage }:

with python3.pkgs;
mkDerivationWith buildPythonApplication rec {

  pname = "blink";
  version = "5.1.7";

  src = fetchdarcs {
    url = "http://devel.ag-projects.com/repositories/blink-qt";
    rev = version;
    sha256 = "sha256-vwUfGfrphEssEceTxkMKSaZkobuZM5o/cLeYMuf9h0U=";
  };

  propagatedBuildInputs = [
    pyqt5_with_qtwebkit
    python3-application
    python3-eventlib
    python3-sipsimple
    google-api-python-client
  ];

  nativeBuildInputs = [
    cython
    copyDesktopItems
  ];

  buildInputs = [
    libvncserver
    xorg.libxcb
  ];

  doCheck = false; # there are none, but test discovery dies trying to import a Windows library
  pythonImportsCheck = [ "blink" ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/bin/blink"
  '';

  postInstall = ''
    mkdir -p "$out/share/pixmaps"
    cp "$out"/share/blink/icons/blink.* "$out/share/pixmaps"
  '';

  desktopItems = [ (makeDesktopItem {
    name = "Blink";
    desktopName = "Blink";
    genericName = "SIP client";
    comment = meta.description;
    extraDesktopEntries = { X-GNOME-FullName = "Blink SIP client"; };
    exec = "blink";
    icon = "blink";
    startupNotify = false;
    terminal = false;
    categories = "Qt;Network;Telephony";
  }) ];

  meta = with lib; {
    homepage = "https://icanblink.com/";
    description = "Fully featured, easy to use SIP client with a Qt based UI";
    longDescription = ''
      Blink is a fully featured SIP client written in Python and built on top of
      SIP SIMPLE client SDK with a Qt based user interface. Blink provides real
      time applications based on SIP and related protocols for Audio, Video,
      Instant Messaging, File Transfers, Desktop Sharing and Presence.
    '';
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub chanley ];
  };
}

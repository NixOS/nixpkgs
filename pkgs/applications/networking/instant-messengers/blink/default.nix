{ lib, fetchdarcs, python2Packages, libvncserver, zlib
, gnutls, libvpx, makeDesktopItem, mkDerivationWith }:

mkDerivationWith python2Packages.buildPythonApplication rec {

  pname = "blink";
  version = "3.2.0";

  src = fetchdarcs {
    url = "http://devel.ag-projects.com/repositories/blink-qt";
    rev = "release-${version}";
    sha256 = "19rcwr5scw48qnj79q1pysw95fz9h98nyc3161qy2kph5g7dwkc3";
  };

  patches = [ ./pythonpath.patch ];
  postPatch = ''
    sed -i 's|@out@|'"''${out}"'|g' blink/resources.py
  '';

  propagatedBuildInputs = with python2Packages; [
    pyqt5_with_qtwebkit
    cjson
    sipsimple
    twisted
    google-api-python-client
  ];

  buildInputs = [
    python2Packages.cython
    zlib
    libvncserver
    libvpx
  ];

  desktopItem = makeDesktopItem {
    name = "Blink";
    exec = "blink";
    comment = meta.description;
    desktopName = "Blink";
    icon = "blink";
    genericName = "Instant Messaging";
    categories = "Internet;";
  };

  dontWrapQtApps = true;

  postInstall = ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/pixmaps"
    cp "$desktopItem"/share/applications/* "$out/share/applications"
    cp "$out"/share/blink/icons/blink.* "$out/share/pixmaps"
  '';

  preFixup = ''
    makeWrapperArgs+=(
      --prefix "LD_LIBRARY_PATH" ":" "${gnutls.out}/lib"
      "''${qtWrapperArgs[@]}"
    )
  '';

  meta = with lib; {
    homepage = "http://icanblink.com/";
    description = "A state of the art, easy to use SIP client for Voice, Video and IM";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}

{ stdenv, fetchdarcs, pythonPackages, libvncserver, zlib
, gnutls, libvpx, makeDesktopItem }:

pythonPackages.buildPythonApplication rec {
  name = "blink-${version}";
  version = "3.0.3";

  src = fetchdarcs {
    url = http://devel.ag-projects.com/repositories/blink-qt;
    rev = "release-${version}";
    sha256 = "1vj6zzfvxygz0fzr8bhymcw6j4v8xmr0kba53d6qg285j7hj1bdi";
  };

  patches = [ ./pythonpath.patch ];
  postPatch = ''
    sed -i 's|@out@|'"''${out}"'|g' blink/resources.py
  '';

  propagatedBuildInputs = with pythonPackages; [ pyqt5 cjson sipsimple twisted google_api_python_client ];

  buildInputs = [ pythonPackages.cython zlib libvncserver libvpx ];

  desktopItem = makeDesktopItem {
    name = "Blink";
    exec = "blink";
    comment = meta.description;
    desktopName = "Blink";
    icon = "blink";
    genericName = "Instant Messaging";
    categories = "Application;Internet;";
  };

  postInstall = ''
    wrapProgram $out/bin/blink \
      --prefix LD_LIBRARY_PATH ":" ${gnutls.out}/lib
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/pixmaps"
    cp "$desktopItem"/share/applications/* "$out/share/applications"
    cp "$out"/share/blink/icons/blink.* "$out/share/pixmaps"
  '';

  meta = with stdenv.lib; {
    homepage = http://icanblink.com/;
    description = "A state of the art, easy to use SIP client for Voice, Video and IM";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
  };
}

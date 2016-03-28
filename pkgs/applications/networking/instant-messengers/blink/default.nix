{ stdenv, fetchurl, pythonPackages, pyqt4, cython, libvncserver, zlib, twisted
, gnutls, libvpx, makeDesktopItem }:

pythonPackages.buildPythonApplication rec {
  name = "blink-${version}";
  version = "2.0.0";
  
  src = fetchurl {
    url = "http://download.ag-projects.com/BlinkQt/${name}.tar.gz";
    sha256 = "07hvy45pavgkvdlh4wbz3shsxh4fapg96qlqmfymdi1nfhwghb05";
  };

  patches = [ ./pythonpath.patch ];
  postPatch = ''
    sed -i 's|@out@|'"''${out}"'|g' blink/resources.py
  '';

  propagatedBuildInputs = with pythonPackages;[ pyqt4 cjson sipsimple twisted
    ];

  buildInputs = [ cython zlib libvncserver libvpx ];

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
      --prefix LD_LIBRARY_PATH ":" ${gnutls}/lib
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

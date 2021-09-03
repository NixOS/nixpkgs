{ lib
, fetchurl
, fetchpatch
, intltool
, libtorrent-rasterbar
, pythonPackages
, gtk3
, glib
, gobject-introspection
, librsvg
, wrapGAppsHook
}:

pythonPackages.buildPythonPackage rec {
  pname = "deluge";
  version = "2.0.3";

  src = fetchurl {
    url = "http://download.deluge-torrent.org/source/2.0/${pname}-${version}.tar.xz";
    sha256 = "14d8kn2pvr1qv8mwqrxmj85jycr73vwfqz12hzag0ararbkfhyky";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/deluge-torrent/deluge/commit/d6c96d629183e8bab2167ef56457f994017e7c85.patch";
      sha256 = "sha256-slGMt2bgp36pjDztJUXFeZNbzdJsus0s9ARRD6IpNUw=";
      name = "fix_ngettext_warning.patch";
    })

    (fetchpatch {
      url = "https://github.com/deluge-torrent/deluge/commit/351664ec071daa04161577c6a1c949ed0f2c3206.patch";
      sha256 = "sha256-ry1LFgMe9lys66xAvATcPqIa3rzBPWVnsf8FL1dXkHo=";
      name = "fix_logging_on_py38.patch";
    })
  ];

  propagatedBuildInputs = with pythonPackages; [
    twisted
    Mako
    chardet
    pyxdg
    pyopenssl
    service-identity
    libtorrent-rasterbar.dev
    libtorrent-rasterbar.python
    setuptools
    setproctitle
    pillow
    rencode
    six
    zope_interface
    dbus-python
    pygobject3
    pycairo
    gtk3
    gobject-introspection
    librsvg
  ];

  nativeBuildInputs = [ intltool wrapGAppsHook glib ];

  checkInputs = with pythonPackages; [
    pytestCheckHook
    pytest-twisted
    pytest-cov
    mock
    mccabe
    pylint
  ];

  doCheck = false; # until pytest-twisted is packaged

  postInstall = ''
    mkdir -p $out/share
    cp -R deluge/ui/data/{icons,pixmaps} $out/share/
    install -Dm444 -t $out/share/applications deluge/ui/data/share/applications/deluge.desktop
  '';

  meta = with lib; {
    homepage = "https://deluge-torrent.org";
    description = "Torrent client";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ domenkozar ebzzry ];
    platforms = platforms.all;
  };
}

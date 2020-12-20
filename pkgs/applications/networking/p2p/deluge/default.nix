{ stdenv, fetchurl, intltool, libtorrent-rasterbar, pythonPackages
, gtk3, glib, gobject-introspection, librsvg, wrapGAppsHook }:

pythonPackages.buildPythonPackage rec {
  pname = "deluge";
  version = "2.0.3";

  src = fetchurl {
    url = "http://download.deluge-torrent.org/source/2.0/${pname}-${version}.tar.xz";
    sha256 = "14d8kn2pvr1qv8mwqrxmj85jycr73vwfqz12hzag0ararbkfhyky";
  };

  propagatedBuildInputs = with pythonPackages; [
    twisted Mako chardet pyxdg pyopenssl service-identity
    libtorrent-rasterbar.dev libtorrent-rasterbar.python setuptools
    setproctitle pillow rencode six zope_interface
    dbus-python pygobject3 pycairo
    gtk3 gobject-introspection librsvg
  ];

  nativeBuildInputs = [ intltool wrapGAppsHook glib ];

  checkInputs = with pythonPackages; [
    pytest /* pytest-twisted */ pytestcov mock
    mccabe pylint
  ];

  doCheck = false; # until pytest-twisted is packaged

  postInstall = ''
     mkdir -p $out/share/applications
     cp -R deluge/ui/data/pixmaps $out/share/
     cp -R deluge/ui/data/icons $out/share/
     cp deluge/ui/data/share/applications/deluge.desktop $out/share/applications
  '';

  meta = with stdenv.lib; {
    homepage = "https://deluge-torrent.org";
    description = "Torrent client";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ domenkozar ebzzry ];
    platforms = platforms.all;
  };
}

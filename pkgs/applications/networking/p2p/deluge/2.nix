{ stdenv, fetchurl, fetchpatch, intltool, python, pythonPackages, libtorrentRasterbar
, gtk3, pango, gettext, wrapGAppsHook, gdk-pixbuf, gobject-introspection, atk, cairo,
 hicolor-icon-theme, gnome3
}:

pythonPackages.buildPythonPackage rec {
  pname = "deluge";
  version = "2.0.3";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/deluge/source/2.0/deluge-${version}.tar.xz";
    sha256 = "14d8kn2pvr1qv8mwqrxmj85jycr73vwfqz12hzag0ararbkfhyky";
  };

  patches = [
  ];

  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [
    gtk3 pango pygobject3 twisted Mako chardet pyxdg pyopenssl service-identity
    libtorrentRasterbar.dev libtorrentRasterbar.python setuptools
    pillow rencode setproctitle 
  ];

  buildInputs = [ gtk3 hicolor-icon-theme gnome3.adwaita-icon-theme ];

  nativeBuildInputs = [ 
    intltool 
    gettext wrapGAppsHook pango gdk-pixbuf atk cairo
    libtorrentRasterbar.dev

    # Temporary fix
    # See https://github.com/NixOS/nixpkgs/issues/61578
    # and https://github.com/NixOS/nixpkgs/issues/56943
    gobject-introspection
  ];

  meta = with stdenv.lib; {
    homepage = https://deluge-torrent.org;
    description = "Torrent client";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ domenkozar ebzzry ];
    platforms = platforms.all;
  };
}

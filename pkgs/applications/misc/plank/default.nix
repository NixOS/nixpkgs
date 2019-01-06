{ stdenv, fetchurl, vala, atk, cairo, glib, gnome3, gtk3, libwnck3
, libX11, libXfixes, libXi, pango, intltool, pkgconfig, libxml2
, bamf, gdk_pixbuf, libdbusmenu-gtk3, file, gnome-menus
, wrapGAppsHook, autoreconfHook, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "plank";
  version = "0.11.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/1.0/${version}/+download/${name}.tar.xz";
    sha256 = "1f41i45xpqhjxql9nl4a1sz30s0j46aqdhbwbvgrawz6himcvdc8";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    libxml2 # xmllint
    wrapGAppsHook
    gobject-introspection
    autoreconfHook
  ];

  buildInputs = [ vala atk cairo glib gnome-menus
                  gtk3 gnome3.libgee libwnck3 libX11 libXfixes
                  libXi pango gnome3.gnome-common bamf gdk_pixbuf
                  libdbusmenu-gtk3 gnome3.dconf ];

  # fix paths
  makeFlags = [
    "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0"
  ];

  # Make plank's application launcher hidden in Pantheon
  patches = [ ./hide-in-pantheon.patch ];

  postPatch = ''
    substituteInPlace ./configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';

  meta = with stdenv.lib; {
    description = "Elegant, simple, clean dock";
    homepage = https://launchpad.net/plank;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ];
  };
}

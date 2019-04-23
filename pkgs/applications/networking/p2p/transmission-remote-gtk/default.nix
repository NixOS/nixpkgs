{ stdenv, autoconf, automake, libtool, wrapGAppsHook, fetchFromGitHub, pkgconfig
, intltool, gtk3, json-glib, curl, glib, autoconf-archive, appstream-glib
, hicolor-icon-theme }:


stdenv.mkDerivation rec {
  name = "transmission-remote-gtk-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "transmission-remote-gtk";
    repo = "transmission-remote-gtk";
    rev = "${version}";
    sha256 = "1pipc1f94jdppv597mqmcj2kw2rdvaqcbl512v7z8vir76p1a7gk";
  };

  preConfigure = "./autogen.sh";

  nativeBuildInputs= [
    autoconf automake libtool wrapGAppsHook
    pkgconfig intltool autoconf-archive
    appstream-glib
  ];

  buildInputs = [ gtk3 json-glib curl glib hicolor-icon-theme ];

  doCheck = false; # fails with style validation error

  meta = with stdenv.lib; {
    description = "GTK remote control for the Transmission BitTorrent client";
    homepage = https://github.com/ajf8/transmission-remote-gtk;
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.linux;
  };
}

{ lib, stdenv, autoconf, automake, libtool, wrapGAppsHook, fetchFromGitHub, pkg-config
, intltool, gtk3, json-glib, curl, glib, autoconf-archive, appstream-glib, fetchpatch }:


stdenv.mkDerivation rec {
  pname = "transmission-remote-gtk";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "transmission-remote-gtk";
    repo = "transmission-remote-gtk";
    rev = version;
    sha256 = "1pipc1f94jdppv597mqmcj2kw2rdvaqcbl512v7z8vir76p1a7gk";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/transmission-remote-gtk/transmission-remote-gtk/commit/0f5cc8a9942e220ea0f7d0b17db4a78d094e3b65.patch";
      sha256 = "195rsjpbc0gzmr9bycvq4mra7abp3hd9by3a5vvcmxsh5ipikycf";
    })
  ];

  preConfigure = "./autogen.sh";

  nativeBuildInputs= [
    autoconf automake libtool wrapGAppsHook
    pkg-config intltool autoconf-archive
    appstream-glib
  ];

  buildInputs = [ gtk3 json-glib curl glib ];

  doCheck = false; # fails with style validation error

  meta = with lib; {
    description = "GTK remote control for the Transmission BitTorrent client";
    homepage = "https://github.com/ajf8/transmission-remote-gtk";
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.linux;
  };
}

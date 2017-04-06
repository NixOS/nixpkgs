{ stdenv, autoconf, automake, libtool, makeWrapper, fetchFromGitHub, pkgconfig
, intltool, gtk3, json_glib, curl, glib, autoconf-archive, appstream-glib }:


stdenv.mkDerivation rec {
  name = "transmission-remote-gtk-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "transmission-remote-gtk";
    repo = "transmission-remote-gtk";
    rev = "${version}";
    sha256 = "02q0vl7achx9rpd0iv0347h838bwzm7aj4k04y88g3bh8fi3cddh";
  };

  preConfigure = "./autogen.sh";

  nativeBuildInputs= [ 
    autoconf automake libtool makeWrapper 
    pkgconfig intltool autoconf-archive 
    appstream-glib
  ];
  buildInputs = [ gtk3 json_glib curl glib ];

  preFixup = ''
    wrapProgram "$out/bin/transmission-remote-gtk" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib;
    { description = "GTK remote control for the Transmission BitTorrent client";
      homepage = https://github.com/ajf8/transmission-remote-gtk;
      license = licenses.gpl2;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux;
    };
}

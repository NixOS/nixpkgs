{ stdenv, autoconf, automake, libtool, makeWrapper, fetchgit, pkgconfig
, intltool, gtk3, json_glib, curl }:


stdenv.mkDerivation rec {
  name = "transmission-remote-gtk-${version}";
  version = "1.2";

  src = fetchgit {
    url = "https://github.com/ajf8/transmission-remote-gtk.git";
    rev = "aa4e0c7d836cfcc10d8effd10225abb050343fc8";
    sha256 = "0qz0jzr5w5fik2awfps0q49blwm4z7diqca2405rr3fyhyjhx42b";
  };

  buildInputs = [ libtool autoconf automake makeWrapper pkgconfig intltool
                  gtk3 json_glib curl ];

  preConfigure = "sh autogen.sh";

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

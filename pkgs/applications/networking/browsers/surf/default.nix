{stdenv, fetchurl, makeWrapper, gtk, webkit, pkgconfig, glib, glib_networking, libsoup, gsettings_desktop_schemas, patches ? null}:

stdenv.mkDerivation rec {
  name = "surf-${version}";
  version="0.7";

  src = fetchurl {
    url = "http://dl.suckless.org/surf/surf-${version}.tar.gz";
    sha256 = "0jj93izd8fizxfa6ln9w1h9bwki81sz5dhskh5x1rl34zd38aq4m";
  };

  buildInputs = [ gtk makeWrapper webkit gsettings_desktop_schemas pkgconfig glib libsoup ];

  # Allow users set their own list of patches
  inherit patches;

  buildPhase = " make ";

  # `-lX11' to make sure libX11's store path is in the RPATH
  NIX_LDFLAGS = "-lX11";
  preConfigure = ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'';
  installFlags = [ "PREFIX=/" "DESTDIR=$(out)" ];

  preFixup = ''
    wrapProgram "$out/bin/surf" \
      --prefix GIO_EXTRA_MODULES : ${glib_networking.out}/lib/gio/modules \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = {
    description = "Simple web browser";
    longDescription = ''
      Surf is a simple web browser based on WebKit/GTK+. It is able to display
      websites and follow links. It supports the XEmbed protocol which makes it
      possible to embed it in another application. Furthermore, one can point
      surf to another URI by setting its XProperties.
      '';
    homepage = http://surf.suckless.org;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}

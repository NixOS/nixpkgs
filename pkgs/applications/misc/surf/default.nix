{stdenv, fetchurl, makeWrapper, gtk, webkit, pkgconfig, glib, glib_networking, libsoup, patches ? null}:

stdenv.mkDerivation rec {
  name = "surf-${version}";
  version="0.6";

  src = fetchurl {
    url = "http://dl.suckless.org/surf/surf-${version}.tar.gz";
    sha256 = "01b8hq8z2wd7ssym5bypx2b15mrs1lhgkrcgxf700kswxvxcrhgx";
  };

  buildInputs = [ gtk makeWrapper webkit pkgconfig glib libsoup ];

  # Allow users set their own list of patches
  inherit patches;

  buildPhase = " make ";

# `-lX11' to make sure libX11's store path is in the RPATH
  NIX_LDFLAGS = "-lX11";
  preConfigure = [ ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'' ];
 installPhase = ''
    make PREFIX=/ DESTDIR=$out install
    wrapProgram "$out/bin/surf" --prefix GIO_EXTRA_MODULES : \
      ${glib_networking}/lib/gio/modules
  '';

  meta = { 
      description = "surf is a simple web browser based on WebKit/GTK+. It is able to display websites and follow links. It supports the XEmbed protocol which makes it possible to embed it in another application. Furthermore, one can point surf to another URI by setting its XProperties.";
      homepage = http://surf.suckless.org;
      license = "MIT";
      platforms = stdenv.lib.platforms.linux;
  };
}

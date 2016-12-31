{ stdenv, fetchurl, scons, pkgconfig, gnome3, gmime, webkitgtk24x, libsass
  , notmuch, boost, makeWrapper }:

stdenv.mkDerivation rec {
  name = "astroid-${version}";
  version = "0.6";

  src = fetchurl {
    url = "https://github.com/astroidmail/astroid/archive/v${version}.tar.gz";
    sha256 = "1d1ivn3vaddlz6bxcgifw4n5jaf7d8y35kk1a457gdq9n1mq87mr";
  };

  patches = [ ./propagate-environment.patch ];

  buildInputs = [ scons pkgconfig gnome3.gtkmm gmime webkitgtk24x libsass
                  gnome3.libpeas notmuch boost gnome3.gsettings_desktop_schemas
                  makeWrapper ];

  buildPhase = "scons --prefix=$out build";
  installPhase = "scons --prefix=$out install";

  preFixup = ''
    wrapProgram "$out/bin/astroid" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = {
    homepage = "https://astroidmail.github.io/";
    description = "GTK+ frontend to the notmuch mail system";
    maintainers = [ stdenv.lib.maintainers.bdimcheff ];
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}

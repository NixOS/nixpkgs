{ stdenv, fetchFromGitHub, scons, pkgconfig, gnome3, gmime, webkitgtk24x
  , libsass, notmuch, boost, makeWrapper }:

stdenv.mkDerivation rec {
  name = "astroid-${version}";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "astroidmail";
    repo = "astroid";
    rev = "v${version}";
    sha256 = "0zashjmqv8ips9q8ckyhgm9hfyf01wpgs6g21cwl05q5iklc5x7r";
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

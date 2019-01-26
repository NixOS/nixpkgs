{ stdenv, fetchurl, pkgconfig, gtk2, gnome2, gnome3, libgksu,
  intltool, libstartup_notification, gtk-doc, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "2.0.2";
  pname = "gksu";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://people.debian.org/~kov/gksu/${name}.tar.gz";
    sha256 = "0npfanlh28daapkg25q4fncxd89rjhvid5fwzjaw324x0g53vpm1";
  };

  nativeBuildInputs = [
    pkgconfig intltool gtk-doc wrapGAppsHook
  ];

  buildInputs = [
    gtk2 gnome2.GConf libstartup_notification gnome3.libgnome-keyring
  ];

  propagatedBuildInputs = [
    libgksu
  ];

  hardeningDisable = [ "format" ];

  patches = [
    # https://savannah.nongnu.org/bugs/index.php?36127
    ./gksu-2.0.2-glib-2.31.patch
  ];

  postPatch = ''
    sed -i -e 's|/usr/bin/x-terminal-emulator|-l gnome-terminal|g' gksu.desktop
  '';

  configureFlags = [ "--disable-nautilus-extension" ];

  meta = {
    description = "A graphical frontend for libgksu";
    longDescription = ''
      GKSu is a library that provides a Gtk+ frontend to su and sudo.
      It supports login shells and preserving environment when acting as
      a su frontend. It is useful to menu items or other graphical
      programs that need to ask a user's password to run another program
      as another user.
    '';
    homepage = https://www.nongnu.org/gksu/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms = stdenv.lib.platforms.linux;
  };
}

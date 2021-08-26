{ lib, stdenv, fetchurl, pkg-config, gtk2, gnome2, gnome, libgksu,
  intltool, libstartup_notification, gtk-doc, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "2.0.2";
  pname = "gksu";

  src = fetchurl {
    url = "http://people.debian.org/~kov/gksu/${pname}-${version}.tar.gz";
    sha256 = "0npfanlh28daapkg25q4fncxd89rjhvid5fwzjaw324x0g53vpm1";
  };

  nativeBuildInputs = [
    pkg-config intltool gtk-doc wrapGAppsHook
  ];

  buildInputs = [
    gtk2 gnome2.GConf libstartup_notification gnome.libgnome-keyring
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
      GKSu is a library that provides a GTK frontend to su and sudo.
      It supports login shells and preserving environment when acting as
      a su frontend. It is useful to menu items or other graphical
      programs that need to ask a user's password to run another program
      as another user.
    '';
    homepage = "https://www.nongnu.org/gksu/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.romildo ];
    platforms = lib.platforms.linux;
  };
}

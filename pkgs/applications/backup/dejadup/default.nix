{ stdenv, fetchurl, cmake, pkgconfig, vala_0_32, 
  gettext, gnome3, libnotify, intltool, itstool, 
  glib, gtk3, packagekit, libsecret }:

stdenv.mkDerivation rec {
  name = "dejadup-${version}";
  version = "34.2"; 

  src = fetchurl {
    url = "https://launchpad.net/deja-dup/34/34.2/+download/deja-dup-34.2.tar.xz";
    sha256 = "ff30732f28233e2422d069f1769a725d4a39c91a279c3bf885c4162fd85818bb";
  };

  # /usr/bin/perl hardcoded.
  patchPhase = ''
    patchShebangs .
  '';

  # couldn't find gio/gdesktopappinfo.h
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  doCheck = true;
  buildInputs = [ cmake pkgconfig vala_0_32 gettext libnotify 
                  gnome3.libpeas intltool itstool glib gtk3 
                  packagekit libsecret ];

  meta = {
    description = "Déjà Dup is a simple backup tool. It hides the complexity of backing up the Right Way (encrypted, off-site, and regular) and uses duplicity as the backend.";
    homepage = "https://launchpad.net/deja-dup";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ s1lvester ];
    platforms = with stdenv.lib.platforms; linux;
  };
}

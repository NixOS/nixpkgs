{ lib, stdenv, fetchurl, pkg-config, wrapGAppsHook, intltool, libgpod, libxml2, curl, flac
, gnome, gtk3, gettext, perlPackages, flex, libid3tag, gdl
, libvorbis, gdk-pixbuf
}:

stdenv.mkDerivation rec {
  version = "2.1.5";
  pname = "gtkpod";

  src = fetchurl {
    url = "mirror://sourceforge/gtkpod/${pname}-${version}.tar.gz";
    sha256 = "0xisrpx069f7bjkyc8vqxb4k0480jmx1wscqxr6cpq1qj6pchzd5";
  };
  postPatch = ''
    sed -i 's/which/type -P/' scripts/*.sh
  '';

  nativeBuildInputs = [ pkg-config wrapGAppsHook intltool ];
  buildInputs = [
    curl gettext
    flex libgpod libid3tag flac libvorbis libxml2 gtk3 gdk-pixbuf
    gdl gnome.adwaita-icon-theme gnome.anjuta
  ] ++ (with perlPackages; [ perl XMLParser ]);

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: .libs/autodetection.o:/build/gtkpod-2.1.5/libgtkpod/gtkpod_app_iface.h:248: multiple definition of
  #       `gtkpod_app'; .libs/gtkpod_app_iface.o:/build/gtkpod-2.1.5/libgtkpod/gtkpod_app_iface.h:248: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "GTK Manager for an Apple ipod";
    homepage = "https://sourceforge.net/projects/gtkpod/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.skeidel ];
  };
}

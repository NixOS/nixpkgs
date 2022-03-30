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

  nativeBuildInputs = [ pkg-config wrapGAppsHook intltool ];
  buildInputs = [
    curl gettext
    flex libgpod libid3tag flac libvorbis libxml2 gtk3 gdk-pixbuf
    gdl gnome.adwaita-icon-theme gnome.anjuta
  ] ++ (with perlPackages; [ perl XMLParser ]);

  patchPhase = ''
    sed -i 's/which/type -P/' scripts/*.sh
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "GTK Manager for an Apple ipod";
    homepage = "http://gtkpod.sourceforge.net";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.skeidel ];
  };
}

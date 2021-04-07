{ lib, stdenv, fetchurl, glib, intltool, libfm, libX11, pango, pkg-config
, wrapGAppsHook, gnome3, withGtk3 ? true, gtk2, gtk3 }:

let
  libfm' = libfm.override { inherit withGtk3; };
  gtk = if withGtk3 then gtk3 else gtk2;
  inherit (lib) optional;
in
stdenv.mkDerivation rec {
  name = "pcmanfm-1.3.2";
  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/${name}.tar.xz";
    sha256 = "sha256-FMt7JHSTxMzmX7tZAmEeOtAKeocPvB5QrcUEKMUUDPc=";
  };

  buildInputs = [ glib gtk libfm' libX11 pango gnome3.adwaita-icon-theme ];
  nativeBuildInputs = [ pkg-config wrapGAppsHook intltool ];

  configureFlags = optional withGtk3 "--with-gtk=3";

  meta = with lib; {
    homepage = "https://blog.lxde.org/category/pcmanfm/";
    license = licenses.gpl2Plus;
    description = "File manager with GTK interface";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
  };
}

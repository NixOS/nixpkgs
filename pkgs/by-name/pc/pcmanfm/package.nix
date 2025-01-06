{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  glib,
  intltool,
  libfm,
  libX11,
  pango,
  pkg-config,
  wrapGAppsHook3,
  adwaita-icon-theme,
  withGtk3 ? true,
  gtk2,
  gtk3,
}:

let
  libfm' = libfm.override { inherit withGtk3; };
  gtk = if withGtk3 then gtk3 else gtk2;
  inherit (lib) optional;
in
stdenv.mkDerivation rec {
  pname = "pcmanfm";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/pcmanfm-${version}.tar.xz";
    sha256 = "sha256-FMt7JHSTxMzmX7tZAmEeOtAKeocPvB5QrcUEKMUUDPc=";
  };

  patches = [
    # Fix build with gcc14 -Werror=incompatible-pointer-types
    (fetchpatch {
      url = "https://github.com/lxde/pcmanfm/commit/12abd7e179adb9e31d999824048a5f40f90218fd.patch";
      hash = "sha256-iuNejg211VOiaIVSNkIV64VIrs6oOp+qwjqz3JFxOTI=";
    })
  ];

  buildInputs = [
    glib
    gtk
    libfm'
    libX11
    pango
    adwaita-icon-theme
  ];
  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    intltool
  ];

  configureFlags = optional withGtk3 "--with-gtk=3";

  meta = with lib; {
    homepage = "https://blog.lxde.org/category/pcmanfm/";
    license = licenses.gpl2Plus;
    description = "File manager with GTK interface";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
    mainProgram = "pcmanfm";
  };
}

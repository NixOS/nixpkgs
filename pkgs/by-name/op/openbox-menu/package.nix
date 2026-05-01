{
  lib,
  gccStdenv,
  fetchurl,
  pkg-config,
  glib,
  gtk2,
  menu-cache,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "openbox-menu";
  version = "0.8.0";

  src = fetchurl {
    url = "https://bitbucket.org/fabriceT/openbox-menu/downloads/openbox-menu-${finalAttrs.version}.tar.bz2";
    hash = "sha256-FPHghHwVES6bSBUqNeNRUA0x55pRQ0iwVMafhKtZJMI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    gtk2
    menu-cache
  ];

  # Enables SVG support by uncommenting the Makefile
  patches = [ ./000-enable-svg.patch ];

  # The strip options are not recognized by Darwin.
  postPatch = lib.optionalString gccStdenv.hostPlatform.isDarwin ''
    sed -i -e '/strip -s/d' Makefile
  '';

  makeFlags = [ "CC=${gccStdenv.cc.targetPrefix}cc" ];

  installFlags = [ "prefix=${placeholder "out"}" ];

  meta = {
    homepage = "http://fabrice.thiroux.free.fr/openbox-menu_en.html";
    description = "Dynamic XDG menu generator for Openbox";
    longDescription = ''
      Openbox-menu is a pipemenu for Openbox window manager. It provides a
      dynamic menu listing installed applications. Most of the work is done by
      the LXDE library menu-cache.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.romildo ];
    platforms = lib.platforms.unix;
    mainProgram = "openbox-menu";
  };
})

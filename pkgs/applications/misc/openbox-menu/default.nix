{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  gtk2,
  menu-cache,
}:

stdenv.mkDerivation rec {
  pname = "openbox-menu";
  version = "0.8.0";

  src = fetchurl {
    url = "https://bitbucket.org/fabriceT/openbox-menu/downloads/${pname}-${version}.tar.bz2";
    sha256 = "1hi4b6mq97y6ajq4hhsikbkk23aha7ikaahm92djw48mgj2f1w8l";
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
  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i -e '/strip -s/d' Makefile
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "http://fabrice.thiroux.free.fr/openbox-menu_en.html";
    description = "Dynamic XDG menu generator for Openbox";
    longDescription = ''
      Openbox-menu is a pipemenu for Openbox window manager. It provides a
      dynamic menu listing installed applications. Most of the work is done by
      the LXDE library menu-cache.
    '';
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.romildo ];
    platforms = platforms.unix;
    mainProgram = "openbox-menu";
  };
}

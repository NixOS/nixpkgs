{
  lib,
  stdenv,
  fetchurl,
  intltool,
  pkg-config,
  glib,
  gtk3,
  lua,
  libwnck,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "devilspie2";
  version = "0.44";

  src = fetchurl {
    url = "mirror://savannah/devilspie2/devilspie2-${finalAttrs.version}.tar.xz";
    hash = "sha256-Cp8erdKyKjGBY+QYAGXUlSIboaQ60gIepoZs0RgEJkA=";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
  ];
  buildInputs = [
    glib
    gtk3
    lua
    libwnck
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp bin/devilspie2 $out/bin
    cp devilspie2.1 $out/share/man/man1
  '';

  meta = {
    description = "Window matching utility";
    longDescription = ''
      Devilspie2 is a window matching utility, allowing the user to
      perform scripted actions on windows as they are created. For
      example you can script a terminal program to always be
      positioned at a specific screen position, or position a window
      on a specific workspace.
    '';
    homepage = "https://www.nongnu.org/devilspie2/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "devilspie2";
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  mono,
  glib,
  pango,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtk-sharp";
  version = "3.22.2";

  src = fetchFromGitHub {
    owner = "GLibSharp";
    repo = "GtkSharp";
    tag = finalAttrs.version;
    hash = "sha256-I15XpW2NotOK1gExCNgJOHd6QVGW9mGkWfeHfJGdLwI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  mesonFlags = [
    "-Dinstall=true"
  ];

  buildInputs = [
    mono
    glib
    pango
    gtk3
  ];

  dontStrip = true;

  patches = [
    (fetchpatch {
      name = "fix-unknown-variable-gdk_api_includes.patch";
      url = "https://github.com/GLibSharp/GtkSharp/commit/a1ffef907e06303bbd2787ced5c82a8bf6a7eef1.patch";
      hash = "sha256-w3BbnEU6ye9WsNBNiELbbGOkXYsE3SACopRF0Dbfr3k=";
    })
  ];

  passthru = {
    inherit gtk3;
  };

  meta = {
    homepage = "https://github.com/GLibSharp/GtkSharp";
    license = lib.licenses.lgpl2Only;
    platforms = lib.platforms.linux;
  };
})

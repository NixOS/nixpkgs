{
  lib,
  stdenv,
  meson,
  ninja,
  cmake,
  gtk-layer-shell,
  bison,
  flex,
  vte,
  fetchFromGitHub,
  gtk3,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "gtkdialog";
  version = "0.8.6-pre";

  src = fetchFromGitHub {
    owner = "puppylinux-woof-CE";
    repo = "gtkdialog";
    # master branch commit that includes the fix for GCC 14
    rev = "db9b3347d2e001c7530f471e7e89c1b34011e7cf";
    hash = "sha256-VaKyR7KJOAHzZ3YrTVDN7DssRNQeWhZExiY79eEZNP4=";
  };

  nativeBuildInputs = [ pkg-config meson ninja cmake bison flex ];
  buildInputs = [ gtk3 gtk-layer-shell vte ];

  meta = {
    homepage = "https://github.com/puppylinux-woof-CE/gtkdialog";
    # community links: http://murga-linux.com/puppy/viewtopic.php?t=111923 -> https://github.com/01micko/gtkdialog
    description = "Small utility for fast and easy GUI building from many scripted and compiled languages";
    mainProgram = "gtkdialog";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}

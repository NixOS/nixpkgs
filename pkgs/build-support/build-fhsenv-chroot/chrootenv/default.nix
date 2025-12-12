{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  glib,
}:

stdenv.mkDerivation {
  name = "chrootenv";
  src = ./src;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ glib ];

  meta = {
    description = "Setup mount/user namespace for FHS emulation";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}

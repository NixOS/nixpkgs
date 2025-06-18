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

  meta = with lib; {
    description = "Setup mount/user namespace for FHS emulation";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

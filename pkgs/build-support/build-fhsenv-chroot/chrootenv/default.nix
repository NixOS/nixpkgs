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

<<<<<<< HEAD
  meta = {
    description = "Setup mount/user namespace for FHS emulation";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Setup mount/user namespace for FHS emulation";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

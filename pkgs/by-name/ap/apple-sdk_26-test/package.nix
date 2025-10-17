{
  lib,
  stdenv,
  meson,
  ninja,
}:

stdenv.mkDerivation {
  name = "apple-sdk_26-test";

  src = ./src;

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta.mainProgram = "apple-sdk_26-test";
}

{
  lib,
  stdenv,
  meson,
  ninja,
  apple-sdk_26,
}:

stdenv.mkDerivation {
  name = "apple-sdk_26-test";

  src = ./src;

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    apple-sdk_26
  ];

  meta.mainProgram = "apple-sdk_26-test";
}

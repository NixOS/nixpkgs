{
  lib,
  stdenv,
  meson,
  ninja,
  apple-sdk_26,
  darwinMinVersionHook
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
    (darwinMinVersionHook "26.0")
  ];

  meta.mainProgram = "apple-sdk_26-test";
}

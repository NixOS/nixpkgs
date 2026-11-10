{
  lib,
  stdenv,
  ninja,
  meson,
  apple-sdk_15,
  apple-sdk_26,
  apple-sdk_27,
}:
{
  apple-sdk_15 = stdenv.mkDerivation {
    name = "apple-sdk_15-test";

    src = ./15;

    nativeBuildInputs = [
      meson
      ninja
    ];

    buildInputs = [
      apple-sdk_15
    ];

    meta.mainProgram = "apple-sdk_15-test";
  };

  apple-sdk_26 = stdenv.mkDerivation {
    name = "apple-sdk_26-test";

    src = ./26;

    nativeBuildInputs = [
      meson
      ninja
    ];

    buildInputs = [
      apple-sdk_26
    ];

    meta.mainProgram = "apple-sdk_26-test";
  };

  apple-sdk_27 = stdenv.mkDerivation {
    name = "apple-sdk_27-test";

    src = ./27;

    nativeBuildInputs = [
      meson
      ninja
    ];

    buildInputs = [
      apple-sdk_27
    ];

    meta.mainProgram = "apple-sdk_27-test";
  };
}

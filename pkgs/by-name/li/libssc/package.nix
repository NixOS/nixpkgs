{
  lib,
  stdenv,
  fetchFromCodeberg,
  meson,
  ninja,
  glib,
  pkg-config,
  libqmi,
  protobufc,
  protobuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libssc";
  version = "0.4.4";

  src = fetchFromCodeberg {
    owner = "DylanVanAssche";
    repo = "libssc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C9A0NtkGztSJQIkv4diGAPhZMUiIUszRNYif2yZL8nI=";
  };

  buildInputs = [
    glib
    protobufc
  ];

  propagatedBuildInputs = [
    libqmi
  ];

  nativeBuildInputs = [
    protobuf
    protobufc
    pkg-config
    meson
    ninja
  ];

  strictDeps = true;

  meta = {
    description = "Library for exposing Qualcomm Sensor Core sensors to Linux";
    homepage = "https://codeberg.org/DylanVanAssche/libssc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "libssc";
    platforms = lib.platforms.all;
  };
})

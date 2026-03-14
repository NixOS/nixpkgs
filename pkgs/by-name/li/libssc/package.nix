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
  version = "0.4.1";

  src = fetchFromCodeberg {
    owner = "DylanVanAssche";
    repo = "libssc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-In2AICWIYsw00L+/C+F5/vAhYTZoTHhWxNLu5jhZcDc=";
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

{
  lib,
  stdenv,
  fetchFromGitea,
  meson,
  ninja,
  glib,
  pkg-config,
  libqmi,
  protobufc,
  protobuf,
}:

stdenv.mkDerivation rec {
  pname = "libssc";
  version = "0.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "DylanVanAssche";
    repo = "libssc";
    tag = "v${version}";
    hash = "sha256-nEGHoWrLxv4IxvqcG8Mv2jhf3QmxNgWevVpUuEnA2xY=";
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
}

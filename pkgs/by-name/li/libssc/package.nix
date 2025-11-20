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
  version = "0.2.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "DylanVanAssche";
    repo = "libssc";
    rev = "v${version}";
    hash = "sha256-ULENnq2MDbA5s0LPB2/Xlx6OatWYlxXF60s1GPGkhlE=";
    fetchSubmodules = true;
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
    pkg-config
    meson
    ninja
  ];

  meta = {
    description = "Library for exposing Qualcomm Sensor Core sensors to Linux";
    homepage = "https://codeberg.org/DylanVanAssche/libssc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "libssc";
    platforms = lib.platforms.all;
  };
}

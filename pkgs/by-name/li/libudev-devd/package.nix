{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  evdev-proto,
  freebsd,
}:

stdenv.mkDerivation rec {
  name = "libudev-devd";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "wulf7";
    repo = "libudev-devd";
    rev = "v${version}";
    hash = "sha256-CrRPJMJRYiYyEIy5XPFk286S87/paf6OfGkEdRPv28I=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    freebsd.libdevinfo
    evdev-proto
  ];

  mesonFlags = [
    "-Denable-gpl=true"
  ];

  meta = {
    description = "libudev-compatible interface for devd";
    homepage = "https://github.com/wulf7/libudev-devd";
    license = with lib.licenses; [
      bsd2
      gpl2
    ];
    maintainers = with lib.maintainers; [ artemist ];
    platforms = lib.platforms.freebsd;
  };
}

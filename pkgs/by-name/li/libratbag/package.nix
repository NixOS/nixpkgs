{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsNoGuiHook,
  gobject-introspection,
  glib,
  systemd,
  udev,
  libevdev,
  gitMinimal,
  check,
  valgrind,
  swig,
  python3,
  json-glib,
  libunistring,
}:

stdenv.mkDerivation rec {
  pname = "libratbag";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "libratbag";
    repo = "libratbag";
    rev = "v${version}";
    hash = "sha256-dAWKDF5hegvKhUZ4JW2J/P9uSs4xNrZLNinhAff6NSc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gitMinimal
    swig
    check
    valgrind
    wrapGAppsNoGuiHook
    gobject-introspection
  ];

  buildInputs = [
    glib
    systemd
    udev
    libevdev
    json-glib
    libunistring
    (python3.withPackages (
      ps: with ps; [
        evdev
        pygobject3
      ]
    ))
  ];

  mesonFlags = [
    "-Dsystemd-unit-dir=./lib/systemd/system/"
  ];

  meta = {
    description = "Configuration library for gaming mice";
    homepage = "https://github.com/libratbag/libratbag";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    platforms = lib.platforms.linux;
  };
}

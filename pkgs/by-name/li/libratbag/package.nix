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

stdenv.mkDerivation (finalAttrs: {
  pname = "libratbag";
  version = "0.18-unstable-2026-07-17";

  src = fetchFromGitHub {
    owner = "libratbag";
    repo = "libratbag";
    rev = "03afbe49f30a4fd18d830530685804eb3bd57c39";
    hash = "sha256-vlo3RfpLJQTw7P5Bmopl8vi4nDrY9OwNM6tVja+scq8=";
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
})

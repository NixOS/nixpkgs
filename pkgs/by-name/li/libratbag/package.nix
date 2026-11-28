{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  wrapGAppsNoGuiHook,
  gobject-introspection,
  glib,
  systemdLibs,
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

  # Fix build with SWIG 4.5
  # FIXME: remove after update
  patches = [
    (fetchpatch {
      url = "https://github.com/libratbag/libratbag/commit/1f4efda9553a5efbbd5be49def22f993ef1410ca.diff";
      hash = "sha256-MXfEJdjUWNp7VfAqe+5rDS7rbZwfhXm/fBV46h7ZJkY=";
    })
  ];

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
    systemdLibs
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

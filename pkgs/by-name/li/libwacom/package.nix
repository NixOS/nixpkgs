{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  pkg-config,
  udev,
  libevdev,
  libgudev,
  python3,
  valgrind,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libwacom";
  version = "2.14.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${finalAttrs.version}";
    hash = "sha256-tJwLcHXXg4tFk7qKQyt+6dcDo8Qykqjn13MfXMoGvKc=";
  };

  postPatch = ''
    patchShebangs test/check-files-in-git.sh
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    python3
  ];

  buildInputs = [
    glib
    udev
    libevdev
    libgudev
  ];

  mesonFlags = [
    (lib.mesonEnable "tests" finalAttrs.doCheck)
    (lib.mesonOption "sysconfdir" "/etc")
  ];

  # Tests are in the `tests` pass-through derivation because one of them is flaky, frequently causing build failures.
  # See https://github.com/NixOS/nixpkgs/issues/328140
  doCheck = false;

  nativeCheckInputs = [
    valgrind
    (python3.withPackages (ps: [
      ps.libevdev
      ps.pytest
      ps.pyudev
    ]))
  ];

  passthru = {
    tests = finalAttrs.finalPackage.overrideAttrs { doCheck = true; };
  };

  meta = {
    platforms = lib.platforms.linux;
    homepage = "https://linuxwacom.github.io/";
    changelog = "https://github.com/linuxwacom/libwacom/blob/${finalAttrs.src.rev}/NEWS";
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
    maintainers = lib.teams.freedesktop.members;
    license = lib.licenses.hpnd;
  };
})

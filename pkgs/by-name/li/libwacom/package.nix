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

let
  testsDisabled = "-Dtests=disabled";
  testsEnabled = "-Dtests=enabled";
  replaceDisabledWithEnabled =
    flag:
    lib.replaceStrings [
      testsDisabled
      testsEnabled
    ] flag;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "libwacom";
  version = "2.12.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "libwacom";
    rev = "libwacom-${finalAttrs.version}";
    hash = "sha256-dxnXh+O/8q8ShsPbpqvaBPNQR6lJBphBolYTmcJEF/0=";
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

  # Tests are in the `tests` pass-through derivation.
  # See https://github.com/NixOS/nixpkgs/issues/328140
  doCheck = false;
  mesonFlags = [
    testsDisabled
    "--sysconfdir=/etc"
  ];

  passthru = {
    tests = finalAttrs.finalPackage.overrideAttrs (prevAttrs: {
      doCheck = true;

      mesonFlags = map replaceDisabledWithEnabled prevAttrs.mesonFlags;

      nativeCheckInputs = [
        valgrind
        (python3.withPackages (ps: [
          ps.libevdev
          ps.pytest
          ps.pyudev
        ]))
      ];
    });
  };

  meta = with lib; {
    platforms = platforms.linux;
    homepage = "https://linuxwacom.github.io/";
    changelog = "https://github.com/linuxwacom/libwacom/blob/${finalAttrs.src.rev}/NEWS";
    description = "Libraries, configuration, and diagnostic tools for Wacom tablets running under Linux";
    maintainers = teams.freedesktop.members;
    license = licenses.hpnd;
  };
})

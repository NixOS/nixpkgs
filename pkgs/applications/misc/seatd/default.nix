{
  fetchFromSourcehut,
  lib,
  meson,
  ninja,
  pkg-config,
  scdoc,
  stdenv,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "seatd";
  version = "0.8.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "seatd";
    rev = finalAttrs.version;
    hash = "sha256-YaR4VuY+wrzbnhER4bkwdm0rTY1OVMtixdDEhu7Lnws=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = lib.optionals systemdSupport [ systemd ];

  mesonFlags = [
    "-Dlibseat-logind=${if systemdSupport then "systemd" else "disabled"}"
    "-Dlibseat-builtin=enabled"
    "-Dserver=enabled"
  ];

  passthru.tests.basic = nixosTests.seatd;

  meta = {
    description = "A minimal seat management daemon, and a universal seat management library";
    changelog = "https://git.sr.ht/~kennylevinsen/seatd/refs/${finalAttrs.version}";
    homepage = "https://sr.ht/~kennylevinsen/seatd/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emantor ];
    platforms = with lib.platforms; freebsd ++ linux ++ netbsd;
    mainProgram = "seatd";
  };
})

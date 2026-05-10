{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  wayland-scanner,
  ronn,
  installShellFiles,
  libevdev,
  libsodium,
  libinput,
  wayland,
  libxkbcommon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kloak";
  version = "0.7.8-1";

  src = fetchFromGitHub {
    owner = "Whonix";
    repo = "kloak";
    tag = finalAttrs.version;
    hash = "sha256-V9t7fQ3K5OIWKhvFiX5Hsf0WzAQUWiZojgbjc38Z1Nk=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    which
    wayland-scanner
    ronn
    installShellFiles
  ];

  buildInputs = [
    libevdev
    libsodium
    libinput
    wayland
    libxkbcommon
  ];

  installPhase = ''
    runHook preInstall

    install -D kloak $out/bin/kloak

    ronn --roff man/kloak.8.ronn
    installManPage man/kloak.8

    runHook postInstall
  '';

  meta = {
    description = "Privacy tool for anonymizing keyboard and mouse use";
    homepage = "https://github.com/Whonix/kloak";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sotormd ];
    mainProgram = "kloak";
    platforms = lib.platforms.linux;
  };
})

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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kloak";
  version = "0.8.0-1";

  src = fetchFromGitHub {
    owner = "Whonix";
    repo = "kloak";
    tag = finalAttrs.version;
    hash = "sha256-lOJLOkswGW5xvFxb9gKQBV3+UMh9/m1nGvH5oKLBkwE=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Privacy tool for anonymizing keyboard and mouse use";
    homepage = "https://github.com/Whonix/kloak";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sotormd ];
    mainProgram = "kloak";
    platforms = lib.platforms.linux;
  };
})

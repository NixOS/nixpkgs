{
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  lib,
  just,
  pkg-config,
  fd,
  libqalculate,
  libxkbcommon,
}:

rustPlatform.buildRustPackage rec {
  pname = "pop-launcher";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "launcher";
    rev = version;
    hash = "sha256-CLpquNgdtnGMlMpGLv72WZmizalvYPfMWlE/qLprVrs=";
  };

  nativeBuildInputs = [
    just
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-client-toolkit-0.1.0" = "sha256-6XM6kcM2CEGAziCkal4uO0EL1nEWOKb3rFs7hFh6r7Y=";
      "switcheroo-control-0.1.0" = "sha256-mklNPKVMO6iFrxki2DwiL5K78KiWpGxksisYldaASIE=";
    };
  };
  cargoBuildFlags = [
    "--package"
    "pop-launcher-bin"
  ];
  cargoTestFlags = [
    "--package"
    "pop-launcher-bin"
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;
  justFlags = [
    "--set"
    "base-dir"
    (placeholder "out")
    "--set"
    "target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release"
  ];

  postPatch = ''
    substituteInPlace justfile --replace-fail '#!/usr/bin/env' "#!$(command -v env)"

    substituteInPlace src/lib.rs \
        --replace-fail '/usr/lib/pop-launcher' "$out/share/pop-launcher"
    substituteInPlace plugins/src/scripts/mod.rs \
        --replace-fail '/usr/lib/pop-launcher' "$out/share/pop-launcher"
    substituteInPlace plugins/src/calc/mod.rs \
        --replace-fail 'Command::new("qalc")' 'Command::new("${libqalculate}/bin/qalc")'
    substituteInPlace plugins/src/find/mod.rs \
        --replace-fail 'spawn("fd")' 'spawn("${fd}/bin/fd")'
    substituteInPlace plugins/src/terminal/mod.rs \
        --replace-fail '/usr/bin/gnome-terminal' 'gnome-terminal'
  '';

  meta = with lib; {
    description = "Modular IPC-based desktop launcher service";
    homepage = "https://github.com/pop-os/launcher";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ samhug ];
    mainProgram = "pop-launcher";
  };
}

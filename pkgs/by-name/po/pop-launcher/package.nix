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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pop-launcher";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "launcher";
    tag = finalAttrs.version;
    hash = "sha256-4wPspv5bpqoG45uUkrtxJTvdbmFkpWv8QBZxsPbGu/M=";
  };

  nativeBuildInputs = [
    just
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
  ];

  cargoHash = "sha256-gc1YhIxHBqmMOE3Gu3T4gmGdAp0t+qiUXDcPYZE6utU=";

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

  meta = {
    description = "Modular IPC-based desktop launcher service";
    homepage = "https://github.com/pop-os/launcher";
    platforms = lib.platforms.linux;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ samhug ];
    mainProgram = "pop-launcher";
    teams = [ lib.teams.cosmic ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  coreutils,
  just,
  libinput,
  libxkbcommon,
  linux-pam,
  pkg-config,
  udev,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-greeter";
  version = "1.0.0-alpha.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-5BSsiGgL369/PePS0FmuE42tktK2bpgJziYuUEnZ2jY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5TXFE/pIeIOvy8x8c5sR3YaI8R2RTA8fzloguIpE4TM=";

  cargoBuildFlags = [ "--all" ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    cmake
    just
    pkg-config
  ];

  buildInputs = [
    libinput
    libxkbcommon
    linux-pam
    udev
    wayland
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-greeter"
    "--set"
    "daemon-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-greeter-daemon"
  ];

  postPatch = ''
    substituteInPlace src/greeter.rs --replace-fail '/usr/bin/env' '${lib.getExe' coreutils "env"}'
  '';

  meta = {
    homepage = "https://github.com/pop-os/cosmic-greeter";
    description = "Greeter for the COSMIC Desktop Environment";
    mainProgram = "cosmic-greeter";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nyabinary ];
    platforms = lib.platforms.linux;
  };
})

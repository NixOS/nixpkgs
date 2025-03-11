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

rustPlatform.buildRustPackage rec {
  pname = "cosmic-greeter";
  version = "1.0.0-alpha.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    rev = "epoch-${version}";
    hash = "sha256-5BSsiGgL369/PePS0FmuE42tktK2bpgJziYuUEnZ2jY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5TXFE/pIeIOvy8x8c5sR3YaI8R2RTA8fzloguIpE4TM=";

  cargoBuildFlags = [
    "--all"
  ];

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

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-greeter";
    description = "Greeter for the COSMIC Desktop Environment";
    mainProgram = "cosmic-greeter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
  };
}

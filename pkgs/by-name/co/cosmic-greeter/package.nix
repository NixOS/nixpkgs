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
  version = "1.0.0-alpha.7";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-greeter";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-o9ZoRHi+k+HCSGfRz1lQFAeJMCqcTQEHf5rf9wn3qqY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hUHkyz/avFu9g1FMdC+4vz6xM75CauurrarhouuVZXc=";

  env.VERGEN_GIT_COMMIT_DATE = "2025-04-25";
  env.VERGEN_GIT_SHA = finalAttrs.src.tag;

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

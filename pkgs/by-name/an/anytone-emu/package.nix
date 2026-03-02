{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage {
  pname = "anytone-emu";
  version = "unstable-2023-06-15";

  src = fetchFromGitHub {
    owner = "hmatuschek";
    repo = "anytone-emu";
    rev = "c6a63b1c9638b48ed0969f90a5e11e2a5fe59458";
    hash = "sha256-Y+7DkenYiwnfVWtMwmtX64sUN7bBVoReEmZQfEjHn8o=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  meta = {
    description = "Tiny emulator for AnyTone radios";
    homepage = "https://github.com/hmatuschek/anytone-emu";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "anytone-emu";
  };
}

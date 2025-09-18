{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "0x";
  version = "0-unstable-2022-07-11";

  src = fetchFromGitHub {
    owner = "mcy";
    repo = "0x";
    rev = "8070704b8efdd1f16bc7e01e393230f16cd8b0a6";
    hash = "sha256-NzD/j8rBfk/cpoBnkFHFqpXz58mswLZr8TUS16vlrZQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    homepage = "https://github.com/mcy/0x";
    description = "Colorful, configurable xxd";
    mainProgram = "0x";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}

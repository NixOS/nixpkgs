{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "lappverk";
  version = "0.1.0-unstable-2025-08-15";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "natkr";
    repo = "lappverk";
    rev = "8f67fab7c6f2544b81af73288052d0ab86bcbf40";
    hash = "sha256-S7xS7zMqoOsMbun4ZGpPHs7vRO+qONbt/0AsTpBcgVU=";
  };

  cargoHash = "sha256-4sD8uTJvX9xaxi/Ert+o/3z+L2bkAqiF4aACWDillnI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  meta = {
    description = "Tool for modifying other people's software";
    homepage = "https://codeberg.org/natkr/lappverk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sinavir ];
    mainProgram = "lappverk";
  };
}

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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lappverk";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "natkr";
    repo = "lappverk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nn0t8PWHAsG631KFWIcgzZBlGiFQmpEqHwLDhfRCNHk=";
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
})

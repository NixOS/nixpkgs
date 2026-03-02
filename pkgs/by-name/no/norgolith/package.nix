{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "norgolith";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "NTBBloodbath";
    repo = "norgolith";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n9Obf2PoTQ8EyxF/i5YU9/AlN9IizWYW/sG89Z8qp1k=";
  };

  cargoHash = "sha256-1DOys3N42jlC/tc5D0Ixg+yXV/RRMIi4qcXzUwpl7XQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  useNextest = true;

  env = {
    LIBGIT2_NO_VENDOR = true;
    OPENSSL_NO_VENDOR = true;
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "The monolithic Norg static site generator built with Rust";
    homepage = "https://norgolith.amartin.beer";
    changelog = "https://github.com/NTBBloodbath/norgolith/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ Ladas552 ];
    mainProgram = "lith";
  };
})

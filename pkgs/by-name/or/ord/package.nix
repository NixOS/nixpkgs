{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ord";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "ordinals";
    repo = "ord";
    rev = finalAttrs.version;
    hash = "sha256-wRc3KauVHvl1Lc1ATXZYtCb2v6LdX1qT+ABTN7BdjAQ=";
  };

  cargoHash = "sha256-3p7K0Zc7/ZnnoOhQedWrg3xm+EK1QE3h4g4Y3idBREo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  dontUseCargoParallelTests = true;

  checkFlags = [
    "--skip=subcommand::server::tests::status" # test fails if it built from source tarball
  ];

  meta = {
    description = "Index, block explorer, and command-line wallet for Ordinals";
    homepage = "https://github.com/ordinals/ord";
    changelog = "https://github.com/ordinals/ord/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ xrelkd ];
    mainProgram = "ord";
  };
})

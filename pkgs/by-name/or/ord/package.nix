{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ord";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "ordinals";
    repo = "ord";
    rev = finalAttrs.version;
    hash = "sha256-KtJfiQs+2XkFT2l/rpyjeGf/i15BsLFHjSQjzOZkRfg=";
  };

  cargoHash = "sha256-4OFkqErFQ/VPvcHdBJTt877wpd1tALTH89U9u1V2KyY=";

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

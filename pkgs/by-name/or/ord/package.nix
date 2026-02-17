{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ord";
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "ordinals";
    repo = "ord";
    rev = finalAttrs.version;
    hash = "sha256-wGwetpZwYuQ6NhZ5to6PTQdhlEz+66iM26x0ZqNfwH0=";
  };

  cargoHash = "sha256-Ziop9cw/jHTrbRZoVBy2Rd93A/YZlLY14Vzfp3vm5xc=";

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

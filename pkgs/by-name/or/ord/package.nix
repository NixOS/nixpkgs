{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ord";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "ordinals";
    repo = "ord";
    rev = finalAttrs.version;
    hash = "sha256-LP/Hgo7seXoNf0IHMpxd2euMmxH1usGCkuYMPmw6jn4=";
  };

  cargoHash = "sha256-qJhTh6nXVlZJ3kAZN2hrZ6XDrv1dk45nX6KRSQ1EbS4=";

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

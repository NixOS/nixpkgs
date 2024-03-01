{ lib, fetchFromGitHub, rustPlatform, pkg-config, udev }:

rustPlatform.buildRustPackage rec {
  pname = "lwk";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Blockstream";
    repo = "lwk";
    rev = "refs/tags/cli_${version}";
    hash = "sha256-+MyD2usM9IfJmS5sP+hsYGhqTquUj9RQUmEt50rMyOs=";
  };

  cargoLock = { lockFile = ./Cargo.lock; };
  cargoBuildFlags = "--bin lwk_cli";

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # tests are disabled since this release had a test compilation error
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ udev ];

  meta = with lib; {
    description = "Liquid Wallet Kit is a CLI program for Liquid descriptor wallets";
    longDescription =
      "Liquid Wallet Kit (LWK) is a CLI program for Liquid descriptor wallets, with support for watch-only, multisig, hardware signers, and asset management.";
    homepage = "https://github.com/Blockstream/lwk";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ delta1 ];
    mainProgram = "lwk_cli";
  };
}

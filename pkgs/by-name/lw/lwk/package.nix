{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, udev }:

rustPlatform.buildRustPackage rec {
  pname = "lwk";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Blockstream";
    repo = "lwk";
    rev = "refs/tags/cli_${version}";
    hash = "sha256-TGtb7YjTd0MLpgB27djm9rTcEjUBX6slotBtLMyxG60=";
  };

  cargoLock = { lockFile = ./Cargo.lock; };
  cargoBuildFlags = "--bin lwk_cli";

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # tests are disabled since this release had a test compilation error
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ udev openssl ];

  meta = with lib; {
    description = "A CLI program for Liquid descriptor wallets";
    longDescription =
      "Liquid Wallet Kit (LWK) is a CLI program for Liquid descriptor wallets, with support for watch-only, multisig, hardware signers, and asset management.";
    homepage = "https://github.com/Blockstream/lwk";
    license = licenses.mit;
    maintainers = with maintainers; [ delta1 ];
    mainProgram = "lwk_cli";
  };
}

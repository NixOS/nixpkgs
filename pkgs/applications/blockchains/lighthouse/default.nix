{ fetchFromGitHub, fetchurl, lib, rustPlatform, stdenv,
  clang, cmake, darwin, llvmPackages, perl, protobuf }:

rustPlatform.buildRustPackage rec {
  pname = "lighthouse";
  version = "v2.5.1";

  src = fetchFromGitHub {
    owner = "sigp";
    repo = pname;
    rev = version;
    hash = "sha256-o8fntnEDRRtxDHsqHTJ3GoHpFtRpuwPQQJ+kxHV1NKA=";
  };

  cargoHash = "sha256-C/qDrlUHby57uqi4xGl3nEYhvVsYRg1AP1tCeOnf47Y=";

  # Do not run tests, because currently some tests require ganache (https://www.npmjs.com/package/ganache),
  # and I haven't figured out how to import ganache into Nixpkgs.
  doCheck = false;

  cargoBuildFlags = [
    # Make only the `lighthouse` executable. Without this, the package produces 7 executables.
    "-p lighthouse"
  ];

  nativeBuildInputs = [
    # https://lighthouse-book.sigmaprime.io/installation-source.html
    clang
    cmake
    llvmPackages.libclang
    perl
    protobuf
  ];

  # https://discourse.nixos.org/t/big-sur-frameworks-issue/10810
  # https://github.com/nix-community/nixpkgs-fmt/issues/7
  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  shellHook = lib.optionalString stdenv.isDarwin ''
    export NIX_LDFLAGS="-F${darwin.apple_sdk.frameworks.Security}/Library/Frameworks -framework Security $NIX_LDFLAGS";
  '';

  # https://github.com/NixOS/nixpkgs/issues/52447
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # These two files are needed by https://github.com/sigp/lighthouse/blob/stable/common/deposit_contract/build.rs
  safe_contracts_file = fetchurl {
    url = "https://raw.githubusercontent.com/ethereum/eth2.0-specs/v0.12.1/deposit_contract/contracts/validator_registration.json";
    sha256 = "sha256-ZslAe1wkmkg8Tua/AmmEfBmjqMVcGIiYHwi+WssEwa8=";
  };

  unsafe_contracts_file = fetchurl {
    url = "https://raw.githubusercontent.com/sigp/unsafe-eth2-deposit-contract/v0.9.2.1/unsafe_validator_registration.json";
    sha256 = "sha256-aeTeHRT3QtxBRSNMCITIWmx89vGtox2OzSff8vZ+RYY=";
  };

  LIGHTHOUSE_DEPOSIT_CONTRACT_SPEC_URL = "file://${safe_contracts_file}";
  LIGHTHOUSE_DEPOSIT_CONTRACT_TESTNET_URL = "file://${unsafe_contracts_file}";
  meta = with lib; {
    description = "An open-source Ethereum consensus client, written in Rust and maintained by Sigma Prime.";
    homepage = "https://github.com/sigp/lighthouse";
    license = licenses.asl20;
    maintainers = with maintainers; [ pmw ];
  };

  # The following logic provides the Web3signer to avoid a network download in
  # https://github.com/sigp/lighthouse/blob/stable/testing/web3signer_tests/build.rs
  LIGHTHOUSE_WEB3SIGNER_VERSION = "22.8.0"; # `tag_name` from https://api.github.com/repos/ConsenSys/web3signer/releases/latest
  web3signer_file = fetchurl {
    url = "https://artifacts.consensys.net/public/web3signer/raw/names/web3signer.zip/versions/${LIGHTHOUSE_WEB3SIGNER_VERSION}/web3signer-${LIGHTHOUSE_WEB3SIGNER_VERSION}.zip";
    sha256 = "sha256-4Fjx8iZEqAzym8EAT8L5TI7aT1I/1IhNURHiX1MADPE=";
  };
}

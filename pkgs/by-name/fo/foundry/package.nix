{ lib
, stdenv
, darwin
, fetchFromGitHub
, libusb1
, nix-update-script
, pkg-config
, rustPlatform
, solc
}:

rustPlatform.buildRustPackage rec {
  pname = "foundry";
  version = "nightly-deb3116955eea4333f9e4e4516104be4182e9ee2";

  src = fetchFromGitHub {
    owner = "foundry-rs";
    repo = "foundry";
    rev = version;
    hash = "sha256-JLRE9apWctPPoX8JLdJUuxJnN1F9hWqJU1n97M87ESA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "alloy-consensus-0.1.0" = "sha256-RfaSuQSHNjJp9Au5CgMTI7ZvwEJywGkCmgrz4t39phQ=";
      "ethers-2.0.11" = "sha256-ySrCZOiqOcDVH5T7gbimK6Bu7A2OCcU64ZL1RfFPrBc=";
      "revm-3.5.0" = "sha256-mI+tecvC9BHXl4+ju4VfYUD3mKO+jp0/KC9KjiyzD+Q=";
      "revm-inspectors-0.1.0" = "sha256-yBqeANijUCBRhOU7XjQvo4H8dbFPFFKErzmZ+Lw4OSA=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.DarwinTools
  ];

  buildInputs = [
    solc
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    libusb1
  ];

  # Tests are run upstream, and many perform I/O
  # incompatible with the nix build sandbox.
  doCheck = false;

  passthru.updateScript = nix-update-script {
    # TODO: Remove this once `foundry` starts providing stable releases.
    extraArgs = [ "--version-regex" "nightly-(.*)" ];
  };

  env = {
    SVM_RELEASES_LIST_JSON =
      if stdenv.isDarwin
      then "${./svm-lists/macosx-amd64.json}"
      else "${./svm-lists/linux-amd64.json}";
  };

  meta = with lib; {
    description = "A portable, modular toolkit for Ethereum application development written in Rust.";
    homepage = "https://github.com/foundry-rs/foundry";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ mitchmindtree ];
    # For now, solc binaries are only built for x86_64.
    # Track darwin-aarch64 here:
    # https://github.com/ethereum/solidity/issues/12291
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}

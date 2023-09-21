{ clang
, cmake
, CoreFoundation
, fetchFromGitHub
, fetchurl
, lib
, lighthouse
, nix-update-script
, nodePackages
, perl
, pkg-config
, postgresql
, protobuf
, rustPlatform
, Security
, sqlite
, stdenv
, SystemConfiguration
, testers
, unzip
}:

rustPlatform.buildRustPackage rec {
  pname = "lighthouse";
  version = "4.1.0";

  # lighthouse/common/deposit_contract/build.rs
  depositContractSpecVersion = "0.12.1";
  testnetDepositContractSpecVersion = "0.9.2.1";

  src = fetchFromGitHub {
    owner = "sigp";
    repo = "lighthouse";
    rev = "v${version}";
    hash = "sha256-QVAFzV9sao8+eegI7bLfm+pPHyvDFhnADS80+nqqgtE=";
  };

  patches = [
    ./use-system-sqlite.patch
  ];

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "amcl-0.3.0" = "sha256-Mj4dXTlGVSleFfuTKgVDQ7S3jANMsdtVE5L90WGxA4U=";
      "arbitrary-1.3.0" = "sha256-BMxcBfxBRf+Kb0Tz55jtFbwokSeD2GPtB+KV8Wbne0g=";
      "beacon-api-client-0.1.0" = "sha256-fI8qST6HZrchg7yr/nVtRNrsW3f5ONSX+mGRYW+iiqA=";
      "ethereum-consensus-0.1.1" = "sha256-aBrZ786Me0BWpnncxQc5MT3r+O0yLQhqGKFBiNTdqSA=";
      "libmdbx-0.1.4" = "sha256-NMsR/Wl1JIj+YFPyeMMkrJFfoS07iEAKEQawO89a+/Q=";
      "lmdb-rkv-0.14.0" = "sha256-sxmguwqqcyOlfXOZogVz1OLxfJPo+Q0+UjkROkbbOCk=";
      "mev-rs-0.2.1" = "sha256-n3ns1oynw5fKQtp/CQHER41+C1EmLCVEBqggkHc3or4=";
      "ssz-rs-0.8.0" = "sha256-k1JLu+jZrSqUyHou76gbJeA5CDWwdL0fPkek3Vzl4Gs=";
      "warp-0.3.2" = "sha256-m9lkEgeSs0yEc+6N6DG7IfQY/evkUMoNyst2hMUR//c=";
    };
  };

  buildFeatures = [ "modern" "gnosis" ];

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    cmake
    perl
    pkg-config
    protobuf
  ];

  buildInputs = [
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
    SystemConfiguration
  ];

  depositContractSpec = fetchurl {
    url = "https://raw.githubusercontent.com/ethereum/eth2.0-specs/v${depositContractSpecVersion}/deposit_contract/contracts/validator_registration.json";
    hash = "sha256-ZslAe1wkmkg8Tua/AmmEfBmjqMVcGIiYHwi+WssEwa8=";
  };

  testnetDepositContractSpec = fetchurl {
    url = "https://raw.githubusercontent.com/sigp/unsafe-eth2-deposit-contract/v${testnetDepositContractSpecVersion}/unsafe_validator_registration.json";
    hash = "sha256-aeTeHRT3QtxBRSNMCITIWmx89vGtox2OzSff8vZ+RYY=";
  };

  LIGHTHOUSE_DEPOSIT_CONTRACT_SPEC_URL = "file://${depositContractSpec}";
  LIGHTHOUSE_DEPOSIT_CONTRACT_TESTNET_URL = "file://${testnetDepositContractSpec}";

  cargoBuildFlags = [
    "--package lighthouse"
  ];

  __darwinAllowLocalNetworking = true;

  checkFeatures = [ ];

  # All of these tests require network access and/or docker
  cargoTestFlags = [
    "--workspace"
    "--exclude beacon_node"
    "--exclude http_api"
    "--exclude beacon_chain"
    "--exclude lighthouse"
    "--exclude lighthouse_network"
    "--exclude slashing_protection"
    "--exclude watch"
    "--exclude web3signer_tests"
  ];

  # All of these tests require network access
  checkFlags = [
    "--skip service::tests::tests::test_dht_persistence"
    "--skip time::test::test_reinsertion_updates_timeout"

  ] ++ lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [
    "--skip subnet_service::tests::sync_committee_service::same_subscription_with_lower_until_epoch"
    "--skip subnet_service::tests::sync_committee_service::subscribe_and_unsubscribe"
  ];

  nativeCheckInputs = [
    nodePackages.ganache
    postgresql
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = lighthouse;
      command = "lighthouse --version";
      version = "v${lighthouse.version}";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Ethereum consensus client in Rust";
    homepage = "https://lighthouse.sigmaprime.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ centromere pmw ];
  };
}

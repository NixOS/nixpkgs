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
, rust-jemalloc-sys
, stdenv
, SystemConfiguration
, testers
, unzip
}:

rustPlatform.buildRustPackage rec {
  pname = "lighthouse";
  version = "4.5.0";

  # lighthouse/common/deposit_contract/build.rs
  depositContractSpecVersion = "0.12.1";
  testnetDepositContractSpecVersion = "0.9.2.1";

  src = fetchFromGitHub {
    owner = "sigp";
    repo = "lighthouse";
    rev = "v${version}";
    hash = "sha256-UUOvTxOQXT1zfhDYEL/J6moHAyejZn7GyGS/XBmXxRQ=";
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
      "amcl-0.3.0" = "sha256-kc8k/ls4W0TwFBsRcyyotyz8ZBEjsZXHeJnJtsnW/LM=";
      "anvil-rpc-0.1.0" = "sha256-L38OioxnWEn94g3GJT4j3U1cJZ8jQDHp8d1QOHaVEuU=";
      "beacon-api-client-0.1.0" = "sha256-Z0CoPxZzl2bjb8vgmHWxq2orMawhMMs7beKGopilKjE=";
      "ethereum-consensus-0.1.1" = "sha256-biTrw3yMJUo9+56QK5RGWXLCoPPZEWp18SCs+Y9QWg4=";
      "libmdbx-0.1.4" = "sha256-NMsR/Wl1JIj+YFPyeMMkrJFfoS07iEAKEQawO89a+/Q=";
      "lmdb-rkv-0.14.0" = "sha256-sxmguwqqcyOlfXOZogVz1OLxfJPo+Q0+UjkROkbbOCk=";
      "mev-rs-0.3.0" = "sha256-LCO0GTvWTLcbPt7qaSlLwlKmAjt3CIHVYTT/JRXpMEo=";
      "testcontainers-0.14.0" = "sha256-mSsp21G7MLEtFROWy88Et5s07PO0tjezovCGIMh+/oQ=";
      "warp-0.3.5" = "sha256-d5e6ASdL7+Dl3KsTNOb9B5RHpStrupOKsbGWsdu9Jfk=";
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
    rust-jemalloc-sys
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
    "--exclude beacon_chain"
    "--exclude http_api"
    "--exclude lighthouse"
    "--exclude lighthouse_network"
    "--exclude slashing_protection"
    "--exclude watch"
    "--exclude web3signer_tests"
  ];

  # All of these tests require network access
  checkFlags = [
    "--skip basic"
    "--skip deposit_tree::cache_consistency"
    "--skip deposit_tree::double_update"
    "--skip deposit_tree::updating"
    "--skip eth1_cache::big_skip"
    "--skip eth1_cache::double_update"
    "--skip eth1_cache::pruning"
    "--skip eth1_cache::simple_scenario"
    "--skip fast::deposit_cache_query"
    "--skip http::incrementing_deposits"
    "--skip persist::test_persist_caches"
    "--skip service::tests::tests::test_dht_persistence"
    "--skip time::test::test_reinsertion_updates_timeout"
  ] ++ lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [
    "--skip subnet_service::tests::attestation_service::test_subscribe_same_subnet_several_slots_apart"
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
    mainProgram = "lighthouse";
  };
}

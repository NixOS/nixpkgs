{ clang
, cmake
, fetchFromGitHub
, fetchurl
, lib
, lighthouse
, llvmPackages
, nodePackages
, perl
, protobuf
, rustPlatform
, Security
, stdenv
, testers
, unzip
}:

rustPlatform.buildRustPackage rec {
  pname = "lighthouse";
  version = "3.2.1";

  # lighthouse/common/deposit_contract/build.rs
  depositContractSpecVersion = "0.12.1";
  testnetDepositContractSpecVersion = "0.9.2.1";

  src = fetchFromGitHub {
    owner = "sigp";
    repo = "lighthouse";
    rev = "v${version}";
    sha256 = "sha256-Aqc3kk1rquhLKNZDlEun4bQpKI4Nsk7+Wr7E2IkJQEs=";
  };

  cargoSha256 = "sha256-wGEk7OfEmyeRW65kq5stvKCdnCjfssyXUmNWGkGq42M=";

  buildFeatures = [ "modern" "gnosis" ];

  nativeBuildInputs = [ clang cmake perl protobuf ];

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

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

  # All of these tests require network access
  cargoTestFlags = [
    "--workspace"
    "--exclude beacon_node"
    "--exclude http_api"
    "--exclude beacon_chain"
    "--exclude lighthouse"
    "--exclude lighthouse_network"
    "--exclude slashing_protection"
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

  checkInputs = [
    nodePackages.ganache
  ];

  passthru.tests.version = testers.testVersion {
    package = lighthouse;
    command = "lighthouse --version";
    version = "v${lighthouse.version}";
  };

  meta = with lib; {
    description = "Ethereum consensus client in Rust";
    homepage = "https://lighthouse.sigmaprime.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ centromere pmw ];
  };
}

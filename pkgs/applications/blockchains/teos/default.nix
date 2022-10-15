{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, llvmPackages
, openssl
, perl
, protobuf
, rustfmt
, Security
, SystemConfiguration
}:

let
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "talaia-labs";
    repo = "rust-teos";
    rev = "v${version}";
    hash = "sha256-N+srREYsADMTqz3uDXpeCuXrZZ62FopXO7DClGfyk9U=";
  };

  common.meta = with lib; {
    homepage = "https://github.com/talaia-labs/rust-teos";
    license = licenses.mit;
    maintainers = with maintainers; [ seberm ];
    platforms = platforms.unix;
  };

  cargoPatches = [ ./add-cargo-lock.patch ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  nativeBuildInputs = [
    perl  # used by openssl-sys to configure
    protobuf
    rustfmt
    llvmPackages.clang
  ];


  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
in
{
  teos = rustPlatform.buildRustPackage {
    pname = "teos";
    cargoSha256 = "sha256-7VYYYSMJ2JP1KuA8sD0X3wInubH/jbA/sgzsTsomyEc=";
    buildAndTestSubdir = "teos";

    inherit version src cargoPatches buildInputs nativeBuildInputs LIBCLANG_PATH;

    meta = common.meta // {
      description = "A Lightning watchtower compliant with BOLT13, written in Rust";
    };

    cargoTestFlags = [
      "--workspace"
    ];
  };

  teos-watchtower-plugin = rustPlatform.buildRustPackage {
    pname = "teos-watchtower-plugin";
    cargoSha256 = "sha256-xL+DiEfgBYJQ1UJm7LAr1/f34pkU8FRl4Seic8MFAlM=";
    buildAndTestSubdir = "watchtower-plugin";

    inherit version src cargoPatches buildInputs nativeBuildInputs LIBCLANG_PATH;

    meta = common.meta // {
      description = "A Lightning watchtower plugin for clightning";
    };

    # The test is skipped due to following error:
    #   thread 'retrier::tests::test_manage_retry_unreachable' panicked at 'assertion failed:
    #   wt_client.lock().unwrap().towers.get(&tower_id).unwrap().status.is_unreachable()', watchtower-plugin/src/retrier.rs:518:9
    checkFlags = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ "--skip=retrier::tests::test_manage_retry_unreachable" ];
  };
}

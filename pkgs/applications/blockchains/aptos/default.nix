{ lib
, llvmPackages_12
, rustPlatform
, fetchFromGitHub
, pkg-config
, rustc
, cargo
, rocksdb
, rustfmt
, postgresql
, openssl
, stdenv
, libiconv
, symlinkJoin
, DiskArbitration
, Foundation
}:

let
  cargoHashes = {
    aptos = "sha256-y9wCwMCtvCu4MzW18MXZ2V+wwhuMkHF2hcevdvW17k4=";
    aptos-node = "sha256-gQabtMi7FpVCJJYeTLebL4d4fQMO6qf9Hhgj1vltR90=";
    aptos-tools = "sha256-FtSOkhHghhnIrrInpGi8n9rWjOB73fjHEBs3lpWbr20=";
  };

  buildAptos =
    { pname
    , cargoSha256
    , cargoBuildFlags ? [ ]
    }:
    rustPlatform.buildRustPackage rec {
      inherit pname cargoBuildFlags cargoSha256;
      version = "unstable-2022-08-26";
      verifyCargoDeps = true;

      src = fetchFromGitHub {
        owner = "aptos-labs";
        repo = "aptos-core";
        # This should be kept up-to-date with the `devnet` branch, which can be found below:
        # https://github.com/aptos-labs/aptos-core/tree/devnet
        rev = "8399cd1c7b9662d3a6a09c28363c5f66f0839c41";
        sha256 = "sha256-XBBX58V+Z+p5ajLwCMlpFGLwe+HEBmyLwqIpDcIq8xU=";
      };

      PKG_CONFIG_PATH = "${lib.getDev openssl}/lib/pkgconfig";
      RUST_SRC_PATH = rustPlatform.rustLibSrc;

      # Needed to get openssl-sys to use pkg-config.
      OPENSSL_NO_VENDOR = 1;
      OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
      OPENSSL_DIR = "${lib.getDev openssl}";

      # ensure we are using LLVM to compile
      LLVM_CONFIG_PATH = "${llvmPackages_12.llvm}/bin/llvm-config";

      # see https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-852079285
      LIBCLANG_PATH = "${llvmPackages_12.libclang.lib}/lib";
      BINDGEN_EXTRA_CLANG_ARGS = with llvmPackages_12;
        "-isystem ${libclang.lib}/lib/clang/${lib.getVersion clang}/include";

      # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
      # try to build RocksDB from source.
      ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
      ROCKSDB_LIB_DIR = "${rocksdb}/lib";

      nativeBuildInputs = [
        pkg-config
        rustc
        cargo
        rustfmt

        llvmPackages_12.llvm
        llvmPackages_12.clang
      ];

      # see: https://github.com/aptos-labs/aptos-core/blob/36dfc6499dd576d7d2ba883b66161510ff5cbe6b/.circleci/config.yml#L241
      buildInputs = [
        rocksdb
        postgresql # libpq
        openssl # libssl
      ] ++ (
        lib.optional stdenv.isDarwin [
          libiconv
          DiskArbitration
          Foundation
        ]
      );

      meta = with lib; {
        description = "A layer 1 for everyone";
        longDescription = ''
          Aptos-core strives towards being the safest and most scalable layer one blockchain
          solution. Today, this powers the Aptos Devnet, tomorrow Mainnet in order to create
          universal and fair access to decentralized assets for billions of people.
        '';
        homepage = "https://aptoslabs.com";
        license = licenses.asl20;
        maintainers = [ maintainers.macalinao ];
      };
    };
in
rec {
  aptos = buildAptos {
    pname = "aptos";
    cargoSha256 = cargoHashes.aptos;
    cargoBuildFlags = [
      "--package"
      "aptos"
    ];
  };

  aptos-node = buildAptos {
    pname = "aptos-node";
    cargoSha256 = cargoHashes.aptos-node;
    cargoBuildFlags = [
      "--package"
      "aptos-node"
    ];
  };

  # The complete list of binaries that form the "production Aptos codebase". These members should
  # never include crates that require fuzzing features or test features. These are the crates we want built with no extra
  # test-only code included.
  #
  # This should exclude any crate that already has a dedicated derivation, i.e.
  # one defined above.
  #
  # See: https://github.com/aptos-labs/aptos-core/blob/1ef2cbcd/Cargo.toml#L130
  aptos-tools = buildAptos {
    pname = "aptos-tools";
    cargoSha256 = cargoHashes.aptos-tools;
    cargoBuildFlags = [
      "--package"
      "aptos-faucet"
      "--package"
      "aptos-keygen"
      "--package"
      "aptos-rate-limiter"
      "--package"
      "aptos-rosetta"
      "--package"
      "transaction-emitter"
      "--package"
      "db-bootstrapper"
      "--package"
      "backup-cli"
      "--package"
      "aptos-indexer"
      "--package"
      "aptos-node-checker"
    ];
  };

  aptos-full = symlinkJoin {
    name = "aptos-full";
    paths = [ aptos aptos-node aptos-tools ];
  };
}

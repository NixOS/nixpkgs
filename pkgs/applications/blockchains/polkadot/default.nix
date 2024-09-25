{ fetchFromGitHub
, lib
, openssl
, pkg-config
, protobuf
, rocksdb_8_3
, rust-jemalloc-sys-unprefixed
, rustPlatform
, rustc
, stdenv
, Security
, SystemConfiguration
}:

let
  rocksdb = rocksdb_8_3;
in
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "stable2407-2";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot-sdk";
    rev = "polkadot-${version}";
    hash = "sha256-4WOoFjihzErc6lIgiWvLg6fqDOxs1A+A0ERvu/D8btw=";

    # the build process of polkadot requires a .git folder in order to determine
    # the git commit hash that is being built and add it to the version string.
    # since having a .git folder introduces reproducibility issues to the nix
    # build, we check the git commit hash after fetching the source and save it
    # into a .git_commit file, and then delete the .git folder. we can then use
    # this file to populate an environment variable with the commit hash, which
    # is picked up by polkadot's build process.
    leaveDotGit = true;
    postFetch = ''
      ( cd $out; git rev-parse --short HEAD > .git_commit )
      rm -rf $out/.git
    '';
  };

  preBuild = ''
    export SUBSTRATE_CLI_GIT_COMMIT_HASH=$(< .git_commit)
    rm .git_commit
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "simple-mermaid-0.1.0" = "sha256-IekTldxYq+uoXwGvbpkVTXv2xrcZ0TQfyyE2i2zH+6w=";
    };
  };

  buildType = "production";

  cargoBuildFlags = [ "-p" "polkadot" ];

  # NOTE: tests currently fail to compile due to an issue with cargo-auditable
  # and resolution of features flags, potentially related to this:
  # https://github.com/rust-secure-code/cargo-auditable/issues/66
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    rustc
    rustc.llvmPackages.lld
  ];

  # NOTE: jemalloc is used by default on Linux with unprefixed enabled
  buildInputs = [ openssl ] ++
    lib.optionals stdenv.hostPlatform.isLinux [ rust-jemalloc-sys-unprefixed ] ++
    lib.optionals stdenv.hostPlatform.isDarwin [ Security SystemConfiguration ];

  # NOTE: disable building `core`/`std` in wasm environment since rust-src isn't
  # available for `rustc-wasm32`
  WASM_BUILD_STD = 0;

  OPENSSL_NO_VENDOR = 1;
  PROTOC = "${protobuf}/bin/protoc";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  meta = with lib; {
    description = "Polkadot Node Implementation";
    homepage = "https://polkadot.network";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ akru andresilva FlorianFranzen RaghavSood ];
    # See Iso::from_arch in src/isa/mod.rs in cranelift-codegen-meta.
    platforms = intersectLists platforms.unix (platforms.aarch64 ++ platforms.s390x ++ platforms.riscv64 ++ platforms.x86);
  };
}

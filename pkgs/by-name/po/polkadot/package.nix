{
  cacert,
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  protobuf,
  rocksdb_8_3,
  rust-jemalloc-sys-unprefixed,
  rustPlatform,
  rustc,
  stdenv,
}:

let
  rocksdb = rocksdb_8_3;
in
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "2506-1";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot-sdk";
    rev = "polkadot-stable${version}";
    hash = "sha256-gnPfhdlOakfm9Ieitl8CBLBht1ECkfXhguK9eNeI6k4=";

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

  cargoHash = "sha256-f6VI8pWZ+yRyFGO347ASD31k3WyBuRixqIUfzBqIr+s=";

  buildType = "production";
  buildAndTestSubdir = "polkadot";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    rustc
    rustc.llvmPackages.lld
  ];

  # NOTE: jemalloc is used by default on Linux with unprefixed enabled
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ rust-jemalloc-sys-unprefixed ];

  checkInputs = [
    cacert
  ];

  doCheck = false;

  OPENSSL_NO_VENDOR = 1;
  PROTOC = "${protobuf}/bin/protoc";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  meta = with lib; {
    description = "Implementation of a https://polkadot.network node in Rust based on the Substrate framework";
    homepage = "https://github.com/paritytech/polkadot-sdk";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      akru
      andresilva
      FlorianFranzen
      RaghavSood
    ];
    # See Iso::from_arch in src/isa/mod.rs in cranelift-codegen-meta.
    platforms = intersectLists platforms.unix (
      platforms.aarch64 ++ platforms.s390x ++ platforms.riscv64 ++ platforms.x86
    );
  };
}

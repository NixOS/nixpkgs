{
  cacert,
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  protobuf,
  rocksdb,
  rust-jemalloc-sys-unprefixed,
  rustPlatform,
  rustc,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polkadot";
  version = "2603-3";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot-sdk";
    rev = "polkadot-stable${finalAttrs.version}";
    hash = "sha256-uNyB7N9M4wQTKQOSFMMOzqhRVwxCJfS+YYE04D3OACQ=";

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

  cargoPatches = [
    # make picosimd compile on nix (https://github.com/koute/picosimd/pull/3)
    ./picosimd-0.9.3.patch
  ];

  cargoHash = "sha256-Y0D7M01fAgDrXKOXsyi4qsyb/2cLRWUcuo0Za01yD8k=";

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

  env = {
    OPENSSL_NO_VENDOR = 1;
    PROTOC = "${protobuf}/bin/protoc";
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";
  };

  meta = {
    description = "Implementation of a https://polkadot.network node in Rust based on the Substrate framework";
    homepage = "https://github.com/paritytech/polkadot-sdk";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      akru
      andresilva
      FlorianFranzen
      RaghavSood
    ];
    # See Iso::from_arch in src/isa/mod.rs in cranelift-codegen-meta.
    platforms = lib.intersectLists lib.platforms.unix (
      lib.platforms.aarch64 ++ lib.platforms.s390x ++ lib.platforms.riscv64 ++ lib.platforms.x86
    );
  };
})

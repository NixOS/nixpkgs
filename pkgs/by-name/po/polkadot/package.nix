{
  cacert,
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  protobuf,
  rocksdb,
  rust-jemalloc-sys-unprefixed,
  rustPlatform,
  rustc,
  stdenv,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "polkadot";
  version = "2609-2";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot-sdk";
    rev = "polkadot-stable${finalAttrs.version}";
    hash = "sha256-kXMJWznzWwneC7h23i3WdFzLRHSP8rwyE5Iox4G3MPk=";

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

  cargoHash = "sha256-Ia4AN9XamXvBEN3q7LZASoPAD7dhnhgz2Sl8Swmmmo8=";

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
    zstd
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=polkadot-stable(\\d{4}(?:-\\d+)?)$" ];
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
    # last successful hydra build on darwin was in 2025
    broken = stdenv.hostPlatform.isDarwin;
  };
})

{ fetchFromGitHub
, lib
, protobuf
, rocksdb
, rust-jemalloc-sys-unprefixed
, rustPlatform
, rustc
, stdenv
, Security
, SystemConfiguration
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot-sdk";
    rev = "polkadot-v${version}";
    hash = "sha256-myQ1TIkytEGdaR3KZOMXK7JK83/Qx46UVhp2GFG7LiA=";

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
      "amcl-0.3.0" = "sha256-EWXQddOskhc07ufRDihn91YRk1fdrLw20N/IoppiWyo=";
      "ark-secret-scalar-0.0.2" = "sha256-91sODxaj0psMw0WqigMCGO5a7+NenAsRj5ZmW6C7lvc=";
      "common-0.1.0" = "sha256-LHz2dK1p8GwyMimlR7AxHLz1tjTYolPwdjP7pxork1o=";
      "ethabi-decode-1.4.0" = "sha256-4sDCsr7OPaaDTs2phA5fdGKqSReYf2HD2IUUh7B43GU=";
      "fflonk-0.1.0" = "sha256-+BvZ03AhYNP0D8Wq9EMsP+lSgPA6BBlnWkoxTffVLwo=";
      "simple-mermaid-0.1.0" = "sha256-IekTldxYq+uoXwGvbpkVTXv2xrcZ0TQfyyE2i2zH+6w=";
      "sp-ark-bls12-381-0.4.2" = "sha256-nNr0amKhSvvI9BlsoP+8v6Xppx/s7zkf0l9Lm3DW8w8=";
      "sp-crypto-ec-utils-0.4.1" = "sha256-/Sw1ZM/JcJBokFE4y2mv/P43ciTL5DEm0PDG0jZvMkI=";
    };
  };

  buildType = "production";

  cargoBuildFlags = [ "-p" "polkadot" ];

  # NOTE: tests currently fail to compile due to an issue with cargo-auditable
  # and resolution of features flags, potentially related to this:
  # https://github.com/rust-secure-code/cargo-auditable/issues/66
  doCheck = false;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustc
    rustc.llvmPackages.lld
  ];

  # NOTE: jemalloc is used by default on Linux with unprefixed enabled
  buildInputs = lib.optionals stdenv.isLinux [ rust-jemalloc-sys-unprefixed ] ++
    lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  # NOTE: disable building `core`/`std` in wasm environment since rust-src isn't
  # available for `rustc-wasm32`
  WASM_BUILD_STD = 0;

  # NOTE: we need to force lld otherwise rust-lld is not found for wasm32 target
  CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER = "lld";
  PROTOC = "${protobuf}/bin/protoc";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  meta = with lib; {
    description = "Polkadot Node Implementation";
    homepage = "https://polkadot.network";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ akru andresilva FlorianFranzen RaghavSood ];
    platforms = platforms.unix;
  };
}

{
  callPackage,
  fetchFromGitea,
  lib,
  llvmPackages,
  nftables,
  nixosTests,
  pkg-config,
  stdenv,
  ...
}:
callPackage ./generic.nix {
  version = "3.5.0";

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "iocaine";
    repo = "iocaine";
    tag = "iocaine-3.5.0";
    hash = "sha256-adsQuSL4F1mfSsUtLwdgUtHVYessBM31tlBU8Rbbst4=";
  };

  cargoHash = "sha256-rGPT0YKQ+p11V4+EOMVZrvEmF1Ylbg0hFpSao+Hqn/4=";

  buildInputs = [
    nftables
  ];

  nativeBuildInputs = [
    pkg-config
    llvmPackages.libclang
  ];

  env = {
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
    BINDGEN_EXTRA_CLANG_ARGS = lib.concatStringsSep " " [
      "-I${llvmPackages.libclang.lib}/lib/clang/${lib.versions.major llvmPackages.release_version}/include"
      "-I${nftables}/include"
      "-I${stdenv.cc.libc.dev}/include"
    ];
  };

  passthru = {
    tests = { inherit (nixosTests) iocaine; };
  };
}

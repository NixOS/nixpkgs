{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cmake,
  protobuf,
  openssl,
  curl,
  zlib,
  zstd,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "semcode";
  version = "0.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "facebookexperimental";
    repo = "semcode";
    tag = finalAttrs.version;
    hash = "sha256-nkb4a+H11gzMGz0zBAH+G77zE+oDl9elTu+bfYmIz9k=";
  };

  cargoHash = "sha256-xOIaoOaHWYhV9z3IoIAfAaRd+AbVBuX8VKomfuFN2QM=";

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    curl
    openssl
    zlib
    zstd
  ];

  dontUseCmakeConfigure = true;

  env = {
    OPENSSL_NO_VENDOR = true;
    PROTOC = lib.getExe' protobuf "protoc";
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # Skip git tests that need git repository
  checkFlags = [
    "--skip=git::tests::test_branch_exists"
    "--skip=git::tests::test_find_merge_base_same_commit"
    "--skip=git::tests::test_get_current_branch"
    "--skip=git::tests::test_list_branches_local"
    "--skip=git::tests::test_list_branches_with_remote"
    "--skip=git::tests::test_resolve_branch_head"
    "--skip=git::tests::test_resolve_branch_main"
  ];

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Semantic code search tool for C/C++";
    homepage = "https://github.com/facebookexperimental/semcode";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "semcode";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})

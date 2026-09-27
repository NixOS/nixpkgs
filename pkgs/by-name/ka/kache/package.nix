{
  cacert,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kache";
  version = "0.26.3";
  __structuredAttrs = true;

  outputs = [ "out" ] ++ lib.optional stdenv.hostPlatform.isUnix "shims";

  src = fetchFromGitHub {
    owner = "kunobi-ninja";
    repo = "kache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7osbe1nDyJmH99oTUvFiWlSPgPkvhO/OCRgxuw6ijtw=";
  };

  cargoHash = "sha256-Mt078AxY84RX+5Lb6q8zdE8R/Qw+e2sd8gouNYWIdXE=";

  cargoBuildFlags = [
    "-p"
    "kache"
  ];
  cargoTestFlags = [
    "-p"
    "kache"
    "--bins" # exclude integration tests
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # The tmutil xattr test shells out to /usr/bin/tmutil which isn't in the sandbox.
    "--skip=store::tests::test_exclude_from_indexing_sets_tmutil_xattr"
    # Nix's sandbox rejects sandbox_apply for these nested sandbox fixtures.
    # The regular macOS CI job runs both against real allowed/denied processes.
    "--skip=fallback::macos::tests::policy_distinguishes_denied_and_allowed_output"
    "--skip=sandbox_preflight_bypasses_denied_server_but_keeps_allowed_server"
  ];

  # [...]/ld.bfd: [...]/libcompiler_builtins-8aaaabbe728a3ecb.rlib(a23574aef39120ab-aarch64.o): undefined reference to symbol '__stack_chk_guard@@GLIBC_2.17'
  # [...]/ld.bfd: [...]/ld-linux-aarch64.so.1: error adding symbols: DSO missing from command line
  env.NIX_LDFLAGS = lib.optionalString (
    stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isGnu
  ) "-lc";

  # planner_client / remote_backend tests bind 127.0.0.1
  __darwinAllowLocalNetworking = true;
  nativeCheckInputs = [ cacert ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isUnix ''
    mkdir -p "$shims/bin"
    for name in cc c++ gcc g++ clang clang++; do
      ln -s "$out/bin/kache" "$shims/bin/$name"
    done
  '';

  meta = {
    description = "Zero-copy, content-addressed build cache for Rust, C/C++ and more";
    homepage = "https://github.com/kunobi-ninja/kache";
    license = lib.licenses.asl20;
    mainProgram = "kache";
    maintainers = with lib.maintainers; [ stefanboca ];
  };
})

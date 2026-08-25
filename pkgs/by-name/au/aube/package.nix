{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cacert,
  cmake,
  nodejs,
  gitMinimal,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aube";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "aube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lV/nxRThPkmGdoCLxH38BZz1SyjNPx1fK0AwL2Ur0EA=";
  };

  cargoHash = "sha256-/W1yGCCXoFwjyEQ9T/TtdklFwvZOhNuMBoer2GmmERs=";

  nativeBuildInputs = [ cmake ]; # libz-ng-sys

  nativeCheckInputs = [
    nodejs
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    rm -f $out/bin/generate-{error-codes,settings}-docs
  '';

  checkFlags = [
    "--skip=spawn_program_tests::spawn_program_runs_the_program_with_its_args"
    "--skip=cli_spec_tests::add_rejects_deny_build_with_dangerously_allow_all_builds"
    "--skip=commands::add_supply_chain::tests::bundled_corpus_detects_common_package_typo"
    "--skip=commands::exec::tests::bin_command_executes_native_target_behind_generated_shim"
    # failed on x86_64-linux
    "--skip=concurrency::tests::floor_and_ceiling_inclusive"
    "--skip=http::ticket_cache::tests::max_per_host_evicts_oldest"
    "--skip=http::ticket_cache::tests::invalidate_removes_all_for_host"
    # failed on aarch64-darwin
    "--skip=facade_install_preserves_non_utf8_storage_paths"
    # require network access
    "--skip=http::ticket_cache::tests::roundtrip_persists_across_open"
  ];

  __darwinAllowLocalNetworking = true;

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Fast Node.js package manager";
    homepage = "https://github.com/jdx/aube";
    changelog = "https://github.com/jdx/aube/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      chillcicada
      Br1ght0ne
    ];
    mainProgram = "aube";
  };
})

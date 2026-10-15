{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "marmite";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "rochacbruno";
    repo = "marmite";
    tag = finalAttrs.version;
    hash = "sha256-5oTwSsE5h5BmMh4Msx3qrre+vMLTxuZrTX42DsXuDr0=";
  };

  cargoHash = "sha256-/X3aGWL+YAJNeVyztl059RGUmfzlxO31HSOnG7SH/VU=";

  # buildRustPackage sets RUST_LOG="" by default, which suppresses marmite's warn! output.
  # These tests assert on that stderr output and would fail otherwise:
  #   test_check_internal_links_warns_on_broken
  #   test_check_media_links_warns_on_broken
  #   test_static_drift_warning_for_core_files
  logLevel = "marmite=warn";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Static Site Generator for Blogs";
    homepage = "https://github.com/rochacbruno/marmite";
    changelog = "https://github.com/rochacbruno/marmite/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "marmite";
  };
})

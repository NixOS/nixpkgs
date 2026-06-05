{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dix";
  version = "2.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = "dix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5aH8zX/Wm+KHzd1fjmjlxjDB+psDG42JAY5U8lrjGDU=";
  };

  cargoHash = "sha256-llStz2BaHBH9iHhfbptAE+Td5HPsvzAlPtXohrCxY4w=";

  env.TMPDIR = "/tmp/";
  checkFlags = [
    "--skip=store::nix_command::tests::test_query_closure_path_info"
    "--skip=store::nix_command::tests::test_query_closure_size"
    "--skip=store::nix_command::tests::test_query_dependents"
    "--skip=store::nix_command::tests::test_query_system_derivations"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/manic-systems/dix";
    description = "Blazingly fast tool to diff Nix related things";
    changelog = "https://github.com/manic-systems/dix/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      faukah
      NotAShelf
    ];
    mainProgram = "dix";
  };
})

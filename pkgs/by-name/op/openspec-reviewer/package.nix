{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openspec-reviewer";
  version = "1.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Sans-Self";
    repo = "OpenSpec-Reviewer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z0Pd0v5sDrjt5TylODAc4xIEMq41mYGX6u8QIWU9RWA=";
  };

  cargoHash = "sha256-kKQ+COtzHPqmH4v9dAnusjQ6FKecLTSjQTfvRcJVBCA=";

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Review OpenSpec changes as semantic diffs";
    homepage = "https://github.com/Sans-Self/OpenSpec-Reviewer";
    changelog = "https://github.com/Sans-Self/OpenSpec-Reviewer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Annoiiyed ];
    mainProgram = "openspec-reviewer";
    platforms = lib.platforms.unix;
  };
})

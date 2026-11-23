{
  lib,
  bash,
  buildGoModule,
  coreutils,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  python3,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "revdiff";
  version = "1.15.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "revdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5KJ8q4cDLiFP64iCAt5NvJ9lm4zF9R9snGRiOtxEGis=";
  };

  vendorHash = null;

  subPackages = [ "app/revdiff" ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    gitMinimal
    python3
  ];

  postPatch = ''
    # Test fixtures run in a sandbox without system interpreter or utility paths.
    substituteInPlace app/revdiff/testdata/plugin-exit-code/*.sh \
      --replace-fail '/usr/bin/env bash' '${lib.getExe bash}'
    substituteInPlace app/revdiff/plugin_exit_code_test.go \
      --replace-fail '/usr/bin/env bash' '${lib.getExe bash}' \
      --replace-fail '/bin/sleep' '${lib.getExe' coreutils "sleep"}' \
      --replace-fail '/usr/bin/touch' '${lib.getExe' coreutils "touch"}'
    patchShebangs --build \
      .claude-plugin/skills/revdiff/scripts \
      plugins/codex/skills/revdiff/scripts \
      plugins/revdiff-planning/scripts
    substituteInPlace \
      .claude-plugin/skills/revdiff/scripts/launch-revdiff.sh \
      plugins/codex/skills/revdiff/scripts/launch-revdiff.sh \
      --replace-fail '/usr/bin/env' '${lib.getExe' coreutils "env"}'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.revision=${finalAttrs.version}"
  ];

  preCheck = ''
    # TestGitTopLevel expects the source directory to be a Git repository.
    git init --initial-branch=main
  '';

  postInstall = ''
    installShellCompletion completions/*
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Terminal interface for reviewing diffs, files, and documents with inline annotations";
    homepage = "https://github.com/umputun/revdiff";
    changelog = "https://github.com/umputun/revdiff/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sheeeng ];
    mainProgram = "revdiff";
  };
})

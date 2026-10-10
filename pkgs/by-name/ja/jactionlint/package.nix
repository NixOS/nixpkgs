{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "jactionlint";
  version = "2.0.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "jactionlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gB3AK1ud/jvFUqUNajEQErTtUlJjf/qv4IHV2/4GtXQ=";
  };

  vendorHash = "sha256-SnP9Siop3zgGrVMuHU2IOqDkPKnfyJZVxUB/iBV8hIA=";

  ldflags = [
    "-s"
    "-X"
    "github.com/jdx/jactionlint/v${lib.versions.major finalAttrs.version}.version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ gitMinimal ];

  # Some tests need a ".git" directory to find the project root, missing from fetchFromGitHub
  preCheck = ''
    git init -q
  '';

  postCheck = ''
    rm -rf .git
  '';

  checkFlags =
    let
      skippedTests = [
        # Golden fixtures embed a zlib-compressed link; the compressed bytes vary by Go version
        "TestMainGenerateOK"
        "TestMainCheckOK"
        "TestMainCheckQuietOK"
        "TestUpdateOK"
        # Golden fixture expects the fallback "(devel)" version, but ldflags above sets a real one
        "TestLinterFormatErrorMessageInSARIF"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Static checker for GitHub Actions workflow files";
    homepage = "https://github.com/jdx/jactionlint";
    changelog = "https://github.com/jdx/jactionlint/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "jactionlint";
  };
})

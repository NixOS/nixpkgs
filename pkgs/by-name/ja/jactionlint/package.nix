{
  lib,
  buildGoModule,
  fetchFromGitHub,
  bashInteractive,
  gitMinimal,
  shellcheck,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "jactionlint";
  version = "2.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "jactionlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-biLyemR356UmjpE8ckN922WgF7WxByrfVs79Y8KQTTw=";
  };

  vendorHash = "sha256-jf7hKPnaSl4iTYT0mtRRAEmgLKAA/lj0vSVoO9+iOvw=";

  ldflags = [
    "-s"
    "-X"
    "github.com/jdx/jactionlint/v${lib.versions.major finalAttrs.version}.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    bashInteractive
    gitMinimal
    shellcheck
  ];

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
        # Golden fixtures expect the fallback "(devel)" version, but ldflags above sets a real one
        "TestLinterFormatErrorMessageInSARIF"
        "TestNoFixGoldens"
        "TestOnlineCoverageGoldens"
        # Needs real internet access, which the build sandbox does not provide
        "TestFetchError/not_found"
        "TestFetchRemoteYAML"
        "TestWriteOutdatedActionAsJSONL"
        "TestDetectNewRelease"
        "TestDetectNoRelease/no_new_version.json"
        "TestCouldNotFetch"
        "TestFetchURL"
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

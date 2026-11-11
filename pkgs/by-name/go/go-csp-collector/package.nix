{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildGo127Module (finalAttrs: {
  pname = "go-csp-collector";
  version = "0.0.27";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = "go-csp-collector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h9CtMzHOQj2ev/9rx8DvdskH7SK31S7i43uezYoHZI8=";
  };

  vendorHash = "sha256-aIvIHFCucqJqGF0EcuJ9lJ2xUM/MvQs4UExSQvphCuE=";

  ldflags = [
    "-s"
    "-X main.Rev=${finalAttrs.version}"
  ];

  postInstall = ''
    install -Dm644 init/go-csp-collector.service $out/lib/systemd/system/go-csp-collector.service

    substituteInPlace $out/lib/systemd/system/go-csp-collector.service \
      --replace-fail "/usr/local/bin/go-csp-collector" "$out/bin/go-csp-collector"
  '';

  __darwinAllowLocalNetworking = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";

  passthru = {
    updateScript = nix-update-script { };
    tests.service = nixosTests.go-csp-collector;
  };

  meta = {
    description = "A content security policy violation collector written in Golang";
    homepage = "https://github.com/jacobbednarz/go-csp-collector";
    changelog = "https://github.com/jacobbednarz/go-csp-collector/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "go-csp-collector";
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
})

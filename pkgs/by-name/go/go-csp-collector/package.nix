{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "go-csp-collector";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = "go-csp-collector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-30+rLt0VonbwP3I09OrAxiCqrUuIvGivE3+6sQ/hnRo=";
  };

  vendorHash = "sha256-gto2lD3atZTy5QMECarLBWQR7Z1bBlFAoJtJYrzg7bY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Rev=${finalAttrs.version}"
  ];

  postInstall = ''
    install -Dm644 init/go-csp-collector.service $out/lib/systemd/system/go-csp-collector.service

    substituteInPlace $out/lib/systemd/system/go-csp-collector.service \
      --replace-fail "/usr/local/bin/go-csp-collector" "$out/bin/go-csp-collector"
  '';

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

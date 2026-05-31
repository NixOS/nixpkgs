{
  lib,
  go_1_26,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

buildGoModule.override { go = go_1_26; } (finalAttrs: {
  pname = "go-csp-collector";
  version = "0.0.17";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = "go-csp-collector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NuJM7MneCptlmX0NV7c/7T1E5xhzM8Z59xNwEEGVuHM=";
  };

  vendorHash = "sha256-YbpBZhXTlSEKkCRDzFeDWRT8HEsCG2905WVGjxvW6oY=";

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

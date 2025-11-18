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
  version = "0.0.16-unstable-2025-11-16";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = "go-csp-collector";
    rev = "cdc16393aeb4be37889f7b82233974ab3eede0f3";
    hash = "sha256-nfEW1kbiImMXHQxryQyKiFL3/xo8xe8V5dalQAGfLXQ=";
  };

  vendorHash = "sha256-SrQahSHO5ZIkcLR3BR5CR5BTStW1pH1Ij1Eql0b3tuU=";

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
    # nixpkgs-update: no auto update
    updateScript = nix-update-script { };
    tests.service = nixosTests.go-csp-collector;
  };

  meta = {
    description = "A content security policy violation collector written in Golang";
    homepage = "https://github.com/jacobbednarz/go-csp-collector";
    changelog = "https://github.com/jacobbednarz/go-csp-collector/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "go-csp-collector";
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
})

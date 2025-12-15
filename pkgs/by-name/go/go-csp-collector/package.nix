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
  version = "0.0.17-unstable-2025-11-24";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = "go-csp-collector";
    rev = "c997e31172ed2d785fc960296b826a9587bd5de9";
    hash = "sha256-ZfE8xa+og14dlUmvYfatecSdrhmuMbFFNTw5RZ3ZHXU=";
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

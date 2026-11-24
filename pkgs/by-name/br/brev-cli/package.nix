{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "brev-cli";
  version = "0.6.337";

  src = fetchFromGitHub {
    owner = "brevdev";
    repo = "brev-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P6LBVQEP/HuKufYrPnn86ZI4a9x+UoZJHalaA0c4heQ=";
  };

  vendorHash = "sha256-hDWqhwdaMkeXSMRJmv+ElL9EvpWTPXgvAxx0Mo/WHNU=";

  subPackages = [ "." ];

  # go-nvml needs lazy binding of libnvidia-ml symbols
  hardeningDisable = [ "bindnow" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=${finalAttrs.src.tag}"
  ];

  postInstall = ''
    mv $out/bin/brev-cli $out/bin/brev
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Connect your laptop to cloud computers";
    mainProgram = "brev";
    homepage = "https://github.com/brevdev/brev-cli";
    changelog = "https://github.com/brevdev/brev-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})

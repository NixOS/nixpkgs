{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "certinfo-go";
  version = "0.1.78";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "certinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jN1dcFbl3c3pMLUwF75VJbEVAYuBv+NPhAFYokprg/4=";
  };

  vendorHash = "sha256-z3cXbjUJPiOAIXFN3B9Zuqg7D3brqqmFAzKctdcabEA=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/certinfo/releases/tag/v${finalAttrs.version}";
    homepage = "https://paepcke.de/certinfo";
    description = "Tool to analyze and troubleshoot x.509 & ssh certificates, encoded keys";
    license = lib.licenses.bsd3;
    mainProgram = "certinfo";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "fabric-ai";
  version = "1.4.99";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "fabric";
    rev = "v${version}";
    hash = "sha256-nf1tBnnRgLDg63a6SmTJPwMKCREr/hfCyYtAyyOCUQU=";
  };

  vendorHash = "sha256-cdopwdIynWJQJO2K6wLZNBT/0JbCRH2tD2UgnNeQTDY=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fabric is an open-source framework for augmenting humans using AI. It provides a modular framework for solving specific problems using a crowdsourced set of AI prompts that can be used anywhere";
    homepage = "https://github.com/danielmiessler/fabric";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jaredmontoya ];
    mainProgram = "fabric";
  };
}

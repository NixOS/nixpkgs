{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "fabric-ai";
  version = "1.4.167";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "fabric";
    rev = "v${version}";
    hash = "sha256-M6YL111YQahrFLaZt+b3EooziCTDpZnO5hGBj1XBVxY=";
  };

  doCheck = false;

  vendorHash = "sha256-ax0ZLvLfbmpzO93xRqonHJz1zHs6u0+Mu0WegR1eW60=";

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

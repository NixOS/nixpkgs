{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "fabric-ai";
  version = "1.4.183";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "fabric";
    tag = "v${version}";
    hash = "sha256-40HOm7T8jwNuEdU+vCfg2eQUh72B67fQaHNLzT6QAN0=";
  };

  vendorHash = "sha256-ZrIzCKhEa00KOS8tauYEGLR4o7gGVVZ9pdfEQbAGDkI=";

  # Fabric introduced plugin tests that fail in the nix build sandbox.
  doCheck = false;

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

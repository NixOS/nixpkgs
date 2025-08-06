{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "fabric-ai";
  version = "1.4.272";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "fabric";
    tag = "v${version}";
    hash = "sha256-4ohZC+TKCKljawf0DAqzNQmEeFXi2jp4571uN+0UqZA=";
  };

  vendorHash = "sha256-wPd0Rgc081ueK12MTeeJfuwUDyFfwXN/MveeOArjkqg=";

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

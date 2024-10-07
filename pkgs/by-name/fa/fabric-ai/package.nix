{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "fabric-ai";
  version = "1.4.54";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "fabric";
    rev = "v${version}";
    hash = "sha256-93kOJLzCoJgj5kApQyzGOZOGDlz6G/aNO7bT7eAs5o8=";
  };

  vendorHash = "sha256-ef5fn3D0DcvluLIlwfZFGS/6bZgkduQhRXvjCrghBL8=";

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

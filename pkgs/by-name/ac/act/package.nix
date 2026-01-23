{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  nix-update-script,
  act,
}:

let
  version = "0.2.84";
in
buildGoModule {
  pname = "act";
  inherit version;

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    tag = "v${version}";
    hash = "sha256-LV6xJI2V68Uwy61mih/siw1vc90EB9maomxeKwgaB68=";
  };

  vendorHash = "sha256-H7MVh/VbkYvivM/4zATfczib3fgk5vYHeQkHsG+cboY=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = act;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kashw2
    ];
  };
}

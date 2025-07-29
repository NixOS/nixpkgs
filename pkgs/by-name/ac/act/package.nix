{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  nix-update-script,
  act,
}:

let
  version = "0.2.79";
in
buildGoModule {
  pname = "act";
  inherit version;

  src = fetchFromGitHub {
    owner = "nektos";
    repo = "act";
    tag = "v${version}";
    hash = "sha256-tIp9iG8SCppg+tX/KdvAON5fKAHAlU01GSJEgvm2JSg=";
  };

  vendorHash = "sha256-wMtRpFUOMia7ZbuKUUkkcr2Gi88fiZydqFSVSAdiKdo=";

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
      Br1ght0ne
      kashw2
    ];
  };
}

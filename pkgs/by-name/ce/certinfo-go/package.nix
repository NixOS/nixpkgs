{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "certinfo-go";
  version = "0.1.50";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "certinfo";
    tag = "v${version}";
    hash = "sha256-MR7JYhYGE0WUwsBoie8wWEWqCGdpl+k4eUWIVVS5CEg=";
  };

  vendorHash = "sha256-3GjVPV8Lwi4yNbIl/IT0fe9yFlWaqqCU1hzfR8H5r7Y=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/certinfo/releases/tag/v${version}";
    homepage = "https://paepcke.de/certinfo";
    description = "Tool to analyze and troubleshoot x.509 & ssh certificates, encoded keys";
    license = lib.licenses.bsd3;
    mainProgram = "certinfo";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}

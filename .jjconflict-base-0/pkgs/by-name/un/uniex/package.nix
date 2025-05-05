{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "uniex";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "uniex";
    tag = "v${version}";
    hash = "sha256-PoGDvnF+P8iUYdW98BT3Gcayf0JSgK257W377yFz5j4=";
  };

  vendorHash = "sha256-QLjeMSdvFSxnmnsKwTg4SDkc7xqx4csxTWJKOsRzcBI=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/paepckehh/uniex/releases/tag/v${version}";
    homepage = "https://paepcke.de/uniex";
    description = "Tool to export unifi network controller mongodb asset information [csv|json].";
    license = lib.licenses.bsd3;
    mainProgram = "uniex";
    maintainers = with lib.maintainers; [ paepcke ];
  };
}

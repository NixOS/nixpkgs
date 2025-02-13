{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "nix-search-tv";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "3timeslazy";
    repo = "nix-search-tv";
    tag = "v${version}";
    hash = "sha256-SKLvN67GHLHGj0bUYdFutiLzRVCCtxNokWP0z3Za9UU=";
  };

  vendorHash = "sha256-uzNDhkovlXx0tIgSJ3E08d0TNmktSrlOOe8Iwi4ZfmU=";

  subPackages = [ "cmd/nix-search-tv" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Nixpkgs channel for television";
    homepage = "https://github.com/3timeslazy/nix-search-tv";
    changelog = "https://github.com/3timeslazy/nix-search-tv/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "nix-search-tv";
  };
}

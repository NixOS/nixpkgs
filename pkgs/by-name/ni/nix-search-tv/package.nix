{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "nix-search-tv";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "3timeslazy";
    repo = "nix-search-tv";
    tag = "v${version}";
    hash = "sha256-bQrn7tX1Pe1glH84OSO96Ud0bG/aq+HxdzQwyNFB3R4=";
  };

  vendorHash = "sha256-hgZWppiy+P3BfoKOMClzCot1shKcGTZnsMCJ/ItxckE=";

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

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "nix-search-tv";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "3timeslazy";
    repo = "nix-search-tv";
    tag = "v${version}";
    hash = "sha256-C8RTUwTkMgROipLgoDrm3L5aTBwOJ+cVr38xx1+sJCQ=";
  };

  vendorHash = "sha256-0spLr6Qn2eQZC5Wwe6d+0o6B3r9CIgJt2X5/E/UMvg8=";

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

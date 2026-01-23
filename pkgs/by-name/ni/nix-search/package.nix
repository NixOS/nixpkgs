{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "nix-search";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = "nix-search";
    rev = "v${version}";
    hash = "sha256-dOdcXKfSwi0THOjtgP3O/46SWoUY+T7LL9nGwOXXJfw=";
  };

  vendorHash = "sha256-bModWDH5Htl5rZthtk/UTw/PXT+LrgyBjsvE6hgIePY=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nix-channel-compatible package search";
    homepage = "https://github.com/diamondburned/nix-search";
    license = lib.licenses.gpl3Only;
    mainProgram = "nix-search";
    maintainers = with lib.maintainers; [ azuwis ];
    platforms = lib.platforms.all;
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nix-search-tv";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "3timeslazy";
    repo = "nix-search-tv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AgFedZzkNuTXJFzIs+U2m0nELjFUwESYUbUCSmh0G3Q=";
  };

  vendorHash = "sha256-hBkro++bjYGrhnq8rmSuKTgnkicagOHTkfRYluSBUX8=";

  subPackages = [ "cmd/nix-search-tv" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fuzzy search for Nix packages";
    homepage = "https://github.com/3timeslazy/nix-search-tv";
    changelog = "https://github.com/3timeslazy/nix-search-tv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "nix-search-tv";
  };
})

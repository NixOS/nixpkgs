{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nix-search-tv";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "3timeslazy";
    repo = "nix-search-tv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YbtM4qfZj0SxbVIFH32UVZhEj0A6oILUOXqkBVz7VCE=";
  };

  vendorHash = "sha256-ZuhU1+XzJeiGheYNR4lL7AI5vgWvgp6iuJjMcK8t6Mg=";

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

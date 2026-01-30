{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nix-search-tv";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "3timeslazy";
    repo = "nix-search-tv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ygA9AF4PrM+4G+Le70UI12OQPIjLmELg3Xpkmc7nMz0=";
  };

  vendorHash = "sha256-ZuhU1+XzJeiGheYNR4lL7AI5vgWvgp6iuJjMcK8t6Mg=";

  subPackages = [ "cmd/nix-search-tv" ];

  env.GOEXPERIMENT = "jsonv2";

  ldflags = [
    "-s"
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

{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "juliaup";
  version = "1.17.13";

  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "juliaup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a1TNWvkEV5mb7Tuy8OqPrQoPwuhrjAzn2wP1vD+IhJo=";
  };

  cargoHash = "sha256-GMu3PVy647TMTg/AYSxkfgFqSvluH/sBSvwbPrNVKe0=";

  checkFlags = [
    # fail due to the filesystem being read-only
    "--skip=command_gc"
    "--skip=command_remove"
  ];

  meta = {
    description = "Julia installer and version multiplexer";
    homepage = "https://github.com/JuliaLang/juliaup";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ reubenj ];
    mainProgram = "juliaup";
  };
})

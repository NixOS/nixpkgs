{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "njq";
  version = "0.0.3.1";

  src = fetchFromGitHub {
    owner = "Rucadi";
    repo = "njq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-evFKm5NYNqIIRVbtMlGFY0k+0sJnkTCTIbTH7w9jQtk=";
  };

  cargoHash = "sha256-tDz9+iQhutlo7petKmg6n/mg0tDntGRqwBALcATJwdM=";

  meta = {
    description = "Command-line JSON processor using nix as query language";
    homepage = "https://github.com/Rucadi/njq";
    mainProgram = "njq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ powwu ];
  };
})

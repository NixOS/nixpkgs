{
  buildGoModule,
  brotli,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "butler";
  version = "15.31.0";

  src = fetchFromGitHub {
    owner = "itchio";
    repo = "butler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gH0aSS5VvKdBr9zD7CGHo3Qhs/MFkJWVMaG9m9yDPXw=";
  };

  buildInputs = [ brotli ];

  doCheck = false; # disabled because the tests don't work in a non-FHS compliant environment.

  vendorHash = "sha256-4Uleff7XO9hs72/G+s8Ak1yaDLNpdHZa2GKx1aCtLZI=";

  meta = {
    description = "Command-line itch.io helper";
    changelog = "https://github.com/itchio/butler/releases/tag/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "http://itch.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ naelstrof ];
  };
})

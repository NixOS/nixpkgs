{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gimoji";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gimoji";
    rev = finalAttrs.version;
    hash = "sha256-9ixaLo3rafOwsPtu+kJodjPBn7AKX/It/0jsnLwCHF4=";
  };

  cargoHash = "sha256-K/2TuHpA7fx/+1uFtl6jclnS1ivVNVCYSqYhONrmQ70=";

  meta = {
    description = "Easily add emojis to your git commit messages";
    homepage = "https://github.com/zeenix/gimoji";
    license = lib.licenses.mit;
    mainProgram = "gimoji";
    maintainers = with lib.maintainers; [ a-kenji ];
  };
})

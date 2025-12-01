{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "age-plugin-xwing";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Rixxc";
    repo = "age-plugin-xwing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SUYFdCckz4H1f5gzR8aCUQdJyvevvjRDugBu109KSPA=";
  };

  cargoHash = "sha256-sm7ZL7eqMiyafxMoYMOpIx3QgEhUItArbjXtb21ktgE=";

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "X-Wing plugin for age";
    homepage = "https://github.com/Rixxc/age-plugin-xwing";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ rixxc ];
    mainProgram = "age-plugin-xwing";
  };
})

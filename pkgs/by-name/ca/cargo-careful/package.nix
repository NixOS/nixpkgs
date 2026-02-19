{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-careful";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${finalAttrs.version}";
    hash = "sha256-huo5KFb+qoPVHNrnR+vb97iNinGaU5d3NbFhAgGCzCk=";
  };

  cargoHash = "sha256-mjGUSwqyqgnGwKjznj8KedIzOJi4GDldJEL0fzpuvec=";

  meta = {
    description = "Tool to execute Rust code carefully, with extra checking along the way";
    mainProgram = "cargo-careful";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})

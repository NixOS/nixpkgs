{
  lib,
  rustPlatform,
  fetchFromGitHub,
  mdbook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-sitemap";
  version = "0.1.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sonneko";
    repo = "mdbook-sitemap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-saLueA7DijUEJ978wZf8TaAh5f7Nu1fDo4+i+wFgXqA=";
  };

  cargoHash = "sha256-7Rlrrnya8axhM4r9NxyONXkVL2lQde1BCfR3o+SIz/k=";

  # the tests generate a book with mdBook with a sitemap
  # so it needs mdbook-sitemap (the built binary) to be in the $PATH
  nativeCheckInputs = [ mdbook ];
  preCheck = ''
    PATH+=":$(echo "$PWD"/target/*/release)"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Renderer tool to generate a sitemap.xml file for an mdBook project";
    homepage = "https://github.com/sonneko/mdbook-sitemap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      pinage404
    ];
    mainProgram = "mdbook-sitemap";
  };
})

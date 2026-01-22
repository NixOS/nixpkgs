{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "newdoc";
  version = "2.18.5";

  src = fetchFromGitHub {
    owner = "redhat-documentation";
    repo = "newdoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oBPF2uN8YketMBmUTRwVLiQ4p1bA48j+9bTcfGTt+os=";
  };

  cargoHash = "sha256-9rpzmrSXqXs9JHi2eupqGUJKc8wWKxAWWoo8VtMauzg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate pre-populated module files formatted with AsciiDoc";
    homepage = "https://redhat-documentation.github.io/newdoc/";
    downloadPage = "https://github.com/redhat-documentation/newdoc";
    changelog = "https://github.com/redhat-documentation/newdoc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "newdoc";
  };
})

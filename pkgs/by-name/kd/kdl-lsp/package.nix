{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kdl-lsp";
  version = "6.7.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kdl-org";
    repo = "kdl-rs";
    tag = "kdl-lsp-v${finalAttrs.version}";
    hash = "sha256-LqKYhJ0puOaqgIfSdw4b8ctWfiRYZmvL8AK3C2v0sSE=";
  };

  cargoHash = "sha256-+5XdCrlnxtdlhj07G2VFL1ICb0Ji+dqxfwJLpZlthmA=";

  cargoBuildFlags = "--package kdl-lsp";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=kdl-lsp-v([\\d.]+)" ];
  };

  meta = {
    description = "LSP server for kdl document language";
    homepage = "https://github.com/kdl-org/kdl-rs";
    changelog = "https://github.com/kdl-org/kdl-rs/blob/kdl-lsp-v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "kdl-lsp";
  };
})

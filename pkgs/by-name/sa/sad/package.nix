{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sad";
  version = "0.4.33";

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "sad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U5IP6QajaaWvhLHtAnI+sUI6i43MGSjDt1ghcGLP8LQ=";
  };

  cargoHash = "sha256-ViAh9e58xlL9qvPnuJ5YqS3YzMmT26FqjCIKsR57qwA=";

  nativeBuildInputs = [ python3 ];

  # fix for compilation on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  prePatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "CLI tool to search and replace";
    homepage = "https://github.com/ms-jpq/sad";
    changelog = "https://github.com/ms-jpq/sad/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      ryan4yin
    ];
    mainProgram = "sad";
  };
})

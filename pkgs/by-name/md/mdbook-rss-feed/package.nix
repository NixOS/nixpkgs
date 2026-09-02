{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  withAtom ? false,
  withJsonFeed ? false,
}:

let
  buildFeatures = lib.optional withAtom "atom" ++ lib.optional withJsonFeed "json-feed";
  hasOptionalFeatures = buildFeatures != [ ];
  withOptionalFeatures = lib.optionalString hasOptionalFeatures " with ${lib.strings.concatStringsSep " and " buildFeatures} features";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-rss-feed";
  version = "1.10.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "saylesss88";
    repo = "mdbook-rss-feed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YqjFURNnhgrUjimM0xZ4lK5Lw8LGu1hyNMGIGKMxQdo=";
  };

  cargoHash = "sha256-tpyPtRbXNnU+mL8Ejbfxo0ajflJDuKh37H5zysT5f8A=";

  inherit buildFeatures;

  passthru.updateScript = nix-update-script { };

  meta = {
    description =
      "mdBook preprocessor that generates a full-content RSS 2.0 feed" + withOptionalFeatures;
    homepage = "https://github.com/saylesss88/mdbook-rss-feed";
    changelog = "https://github.com/saylesss88/mdbook-rss-feed/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      pinage404
    ];
    mainProgram = "mdbook-rss-feed";
  };
})

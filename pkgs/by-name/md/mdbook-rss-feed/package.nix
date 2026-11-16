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
  version = "2.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "saylesss88";
    repo = "mdbook-rss-feed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1NQ9prk+MvTj7vMJelCfHhs/0/HiHk0/tQURPVjtYh4=";
  };

  cargoHash = "sha256-4qZQ2EH+GBb08GwNnTDAZsjVK6EPKUqL/+wrMH88D4c=";

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
      saylesss88
      pinage404
    ];
    mainProgram = "mdbook-rss-feed";
  };
})

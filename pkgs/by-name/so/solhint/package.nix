{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "solhint";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "protofire";
    repo = "solhint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4AtEBmioWVJBPq/6KLUYYV0vaMOIVRUiFUkhkqTwF1o=";
  };

  npmDepsHash = "sha256-kLqZNxV4JP3zSpiF5S9TVOKPC1TWSGZPrJcwriY/Th0=";

  npmBuildScript = "prepublishOnly";

  meta = {
    description = "Linter for solidity code";
    homepage = "https://github.com/protofire/solhint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rookeur ];
    mainProgram = "solhint";
  };
})

{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "maski";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ManUtopiK";
    repo = "maski";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-NLao3RtN+1/Mb/SnP+WA0fYa6pu/+5wyTOwlWp0BAbQ=";
  };

  cargoHash = "sha256-CnoXPGn0n8SiAkEFZq6xrbiNDx/jOAIh2/w42l1Zfb0=";

  meta = {
    description = "Interactive TUI for mask — browse and run maskfile commands with fuzzy search";
    homepage = "https://github.com/ManUtopiK/maski";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ManUtopiK ];
    mainProgram = "maski";
    platforms = lib.platforms.unix;
  };
})

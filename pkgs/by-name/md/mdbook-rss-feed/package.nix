{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-rss-feed";
  version = "1.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "saylesss88";
    repo = "mdbook-rss-feed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uIEl9lHHsTMV+ft9Zn42zzL1A8HRV17zuf/FBh973/E=";
  };

  cargoHash = "sha256-/tm0rciW4Nif3nfAokZ1P2eDkC1hXY6owccyev+kVZ0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "mdBook preprocessor that generates a full-content RSS 2.0 feed";
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

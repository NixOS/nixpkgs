{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  nodejs,
  pnpm,
  pnpmConfigHook,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obsidian-headless";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "obsidianmd";
    repo = "obsidian-headless";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b69b55e9261d05fb7c4c0ec82f6dc2b6af81b359";
  };

  nativeBuildInputs = [
    nodejs # in case scripts are run outside of a pnpm call
    pnpmConfigHook
    pnpm # At least required by pnpmConfigHook, if not other (custom) phases
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-b69b55e9261d05fb7c4c0ec82f6dc2b6af81b359";
  };

  meta = {
    description = "Headless client for Obsidian Sync. Sync your vaults from the command line without the desktop app. ";
    homepage = "https://obsidian.md/sync";
    license = lib.licenses.unfree;
    mainProgram = "ob";
    maintainers = with lib.maintainers; [ of-the-stars ];
  };
})

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
  pnpm_10_latest,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "flood";
  version = "4.14.2";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "flood";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gSjkpAGkvgRRh8WDpL/F7fS8KDxHRJUuWVqHGcFEGAc=";
  };

  nativeBuildInputs = [ pnpm_10_latest ];
  npmConfigHook = pnpmConfigHook;
  npmDeps = finalAttrs.pnpmDeps;
  dontNpmPrune = true;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_10_latest;
    fetcherVersion = 4;
    hash = "sha256-yNRC5sCBn002gxUfHMUvh3DZeVYOokfz4MTvqXR2MzI=";
  };

  passthru = {
    tests = {
      inherit (nixosTests) flood;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern web UI for various torrent clients with a Node.js backend and React frontend";
    homepage = "https://flood.js.org";
    changelog = "https://github.com/jesec/flood/releases/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      azahi
      thiagokokada
      winter
      ners
    ];
    mainProgram = "flood";
  };
})

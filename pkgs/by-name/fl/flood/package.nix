{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "flood";
  version = "4.13.10";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "flood";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b2Va/t1yiIo1cmxSXfFd74z7pc3NjRCktioqEKxzUJI=";
  };

  nativeBuildInputs = [ pnpm_9 ];
  npmConfigHook = pnpmConfigHook;
  npmDeps = finalAttrs.pnpmDeps;
  dontNpmPrune = true;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-NQ6SJ0etny+HE4ND/2s28Sbfi7vr+YnjCBfVB0OKWqM=";
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

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
}:
=======
  nix-update-script,
}:

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
buildNpmPackage rec {
  pname = "flood";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "flood";
    rev = "v${version}";
    hash = "sha256-RBWDEFhLEZdC7luGFGx3qY0Hk7nM44RZgRyCWXFPh1k=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ pnpm_9 ];
  npmConfigHook = pnpmConfigHook;
  npmDeps = pnpmDeps;
  dontNpmPrune = true;
  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    pnpm = pnpm_9;
=======
  npmConfigHook = pnpm_9.configHook;
  npmDeps = pnpmDeps;
  dontNpmPrune = true;
  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetcherVersion = 1;
    hash = "sha256-MnsUTXcLMT0Q2bQ/rRD4FfJx8XP9TLiv1oTHIgnMZCQ=";
  };

  passthru = {
    tests = {
      inherit (nixosTests) flood;
    };
    updateScript = nix-update-script { };
  };

<<<<<<< HEAD
  meta = {
    description = "Modern web UI for various torrent clients with a Node.js backend and React frontend";
    homepage = "https://flood.js.org";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Modern web UI for various torrent clients with a Node.js backend and React frontend";
    homepage = "https://flood.js.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      thiagokokada
      winter
      ners
    ];
    mainProgram = "flood";
  };
}

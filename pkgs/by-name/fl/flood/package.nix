{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
  pnpm_9,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "flood";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "flood";
    rev = "v${version}";
    hash = "sha256-RBWDEFhLEZdC7luGFGx3qY0Hk7nM44RZgRyCWXFPh1k=";
  };

  npmConfigHook = pnpm_9.configHook;
  npmDeps = pnpmDeps;
  dontNpmPrune = true;
  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    fetcherVersion = 1;
    hash = "sha256-MnsUTXcLMT0Q2bQ/rRD4FfJx8XP9TLiv1oTHIgnMZCQ=";
  };

  passthru = {
    tests = {
      inherit (nixosTests) flood;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Modern web UI for various torrent clients with a Node.js backend and React frontend";
    homepage = "https://flood.js.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      thiagokokada
      winter
      ners
    ];
    mainProgram = "flood";
  };
}

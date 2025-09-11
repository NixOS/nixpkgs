{ lib
, buildNpmPackage
, fetchFromGitHub
, nixosTests
, pnpm_9
, nix-update-script
}:

buildNpmPackage rec {
  pname = "flood";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-R8OWr9jsD6KZ3P827plCTSLcVrrFEdutmlZNwqXJNfU=";
  };

  npmConfigHook = pnpm_9.configHook;
  npmDeps = pnpmDeps;
  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-6YW2m7siLzHiAFEpidQS5okhjsY9qNm+Ro8mHex1/No=";
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
    maintainers = with maintainers; [ thiagokokada winter ners ];
    mainProgram = "flood";
  };
}

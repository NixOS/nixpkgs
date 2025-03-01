{ lib
, buildNpmPackage
, fetchFromGitHub
, nixosTests
, pnpm_9
, nix-update-script
}:

buildNpmPackage rec {
  pname = "flood";
  version = "4.9.3";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sIwXx9DA+vRW4pf6jyqcsla0khh8fdpvVTZ5pLrUhhc=";
  };

  npmConfigHook = pnpm_9.configHook;
  npmDeps = pnpmDeps;
  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-E2VxRcOMLvvCQb9gCAGcBTsly571zh/HWM6Q1Zd2eVw=";
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

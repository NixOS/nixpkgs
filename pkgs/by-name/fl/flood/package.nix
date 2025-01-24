{ lib
, buildNpmPackage
, fetchFromGitHub
, nixosTests
, pnpm
, nix-update-script
}:

buildNpmPackage rec {
  pname = "flood";
  version = "4.8.5";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lm+vPo7V99OSUAVEvdiTNMlD/+iHGPIyPLc1WzO1aTU=";
  };

  npmConfigHook = pnpm.configHook;
  npmDeps = pnpmDeps;
  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-NuU9O3bEboxmuEuk1WSUeZRNgVK5cwFiUAN3+7vACGw=";
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

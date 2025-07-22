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
  version = "4.9.5";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "flood";
    rev = "v${version}";
    hash = "sha256-UXapL26PsSJvWX4Vjj/JJC/FsUBLuGEoqv2dSRSQqNg=";
  };

  npmConfigHook = pnpm_9.configHook;
  npmDeps = pnpmDeps;
  dontNpmPrune = true;
  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    fetcherVersion = 2;
    hash = "sha256-a2ii7sPF/m0fJeS6Y4Ueu2z+oXB1s7Bqh/yv1Zj+RMw=";
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

{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  stardust-xr-atmosphere,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "stardust-xr-atmosphere";
  version = "0.50.0-unstable-2026-01-12";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "atmosphere";
    rev = "8b160f3bf5b477a2e1a3721b239cdfaef75de35a";
    hash = "sha256-DlxhHlNyNPK/oUcDnx4xyGiUMpPjHO4Zgc0/2yvgvXk=";
  };

  cargoHash = "sha256-zYz76cQ8M9nAlJ90THbf0Ap5G9RjNIpIMyLJmKJnnyE=";

  passthru = {
    tests.versionTest = testers.testVersion {
      package = stardust-xr-atmosphere;
      command = "atmosphere --version";
      version = "stardust-xr-atmosphere 0.4.0";
    };
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "Environment, homespace, and setup client for Stardust XR";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "atmosphere";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}

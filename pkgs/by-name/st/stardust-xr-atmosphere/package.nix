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
  version = "0.5.0-unstable-2025-12-01";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "atmosphere";
    rev = "af38adafe7491498c48905b77518f8a6e9541f67";
    hash = "sha256-gKTnshohcRHITr/kpQz/rBxCqdSHO4FkIDkid9Q1XX8=";
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

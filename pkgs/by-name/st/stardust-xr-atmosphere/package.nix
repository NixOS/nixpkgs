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
  version = "0.51.1-unstable-2026-03-22";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "atmosphere";
    rev = "81927a7057f4f5aa1baab8dbb498e03c71e81eb5";
    hash = "sha256-QsurrxkJ3bqmsHIe4vlOwvp19yA0Ak09c9bBT2BmMiQ=";
  };

  cargoHash = "sha256-y9zg/69wo0U9opN3D9laRaJa1zlsZJZgloYOm9qm7H4=";

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

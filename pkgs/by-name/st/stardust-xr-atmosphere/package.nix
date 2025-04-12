{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  stardust-xr-atmosphere,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-atmosphere";
  version = "0-unstable-2024-08-22";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "atmosphere";
    rev = "0c8bfb91e8ca32a4895f858067334ed265517309";
    hash = "sha256-pk1+kkPV6fx+7Xz9hKFFVw402iztcvNC31zVCc3hfTY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "stardust-xr-0.45.0" = "sha256-WF/uNtFYB+ZQqsyXJe7qUCd8SHUgaNOLMxGuNIN1iKM=";
      "stardust-xr-molecules-0.45.0" = "sha256-UldPQQ0Psx/lFUdCKJJDeG8W6lK6qDU3JSwffawK3xg=";
    };
  };

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

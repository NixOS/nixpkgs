{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "sway-scratch";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "aokellermann";
    repo = "sway-scratch";
    rev = "v${version}";
    hash = "sha256-1N/33XtkEWamgQYNDyZgSSaaGD+2HtbseEpQgrAz3CU=";
  };

  cargoHash = "sha256-Z+ls6OCrDkmfxRTD+DOQhr7p183RRhXaXm8a/mWBixw=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Automatically starting named scratchpads for sway";
    homepage = "https://github.com/aokellermann/sway-scratch";
    license = licenses.mit;
    maintainers = with maintainers; [ LilleAila ];
    mainProgram = "sway-scratch";
    platforms = lib.platforms.linux;
  };
}

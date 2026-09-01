{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sway-scratch";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "aokellermann";
    repo = "sway-scratch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1N/33XtkEWamgQYNDyZgSSaaGD+2HtbseEpQgrAz3CU=";
  };

  cargoHash = "sha256-ba0d7rbGwK3KNxd6pdoqqCwfHrs/Lt7hl0APkGT+0gw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatically starting named scratchpads for sway";
    homepage = "https://github.com/aokellermann/sway-scratch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ LilleAila ];
    mainProgram = "sway-scratch";
    platforms = lib.platforms.linux;
  };
})

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

  cargoHash = "sha256-ba0d7rbGwK3KNxd6pdoqqCwfHrs/Lt7hl0APkGT+0gw=";

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
    description = "Automatically starting named scratchpads for sway";
    homepage = "https://github.com/aokellermann/sway-scratch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ LilleAila ];
=======
  meta = with lib; {
    description = "Automatically starting named scratchpads for sway";
    homepage = "https://github.com/aokellermann/sway-scratch";
    license = licenses.mit;
    maintainers = with maintainers; [ LilleAila ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "sway-scratch";
    platforms = lib.platforms.linux;
  };
}

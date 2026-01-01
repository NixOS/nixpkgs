{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "angle-grinder";
  version = "0.19.4";

  src = fetchFromGitHub {
    owner = "rcoh";
    repo = "angle-grinder";
    tag = "v${version}";
    sha256 = "sha256-1SZho04qJcNi84ZkDmxoVkLx9VJX04QINZQ6ZEoCq+c=";
  };

  cargoHash = "sha256-B7JFwFzE8ZvbTjCUZ6IEtjavPGkx3Nb9FMSPbNFqiuU=";

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

<<<<<<< HEAD
  meta = {
    description = "Slice and dice logs on the command line";
    homepage = "https://github.com/rcoh/angle-grinder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bbigras ];
=======
  meta = with lib; {
    description = "Slice and dice logs on the command line";
    homepage = "https://github.com/rcoh/angle-grinder";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "agrind";
  };
}

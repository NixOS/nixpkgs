{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "erdtree";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "solidiquis";
    repo = "erdtree";
    rev = "v${version}";
    hash = "sha256-rm3j1exvdlJtMXgFeRmzr3YU/sLpQFL3PCa8kLVlinM=";
  };

  cargoHash = "sha256-qmSkMoTAwZz7Bn+r67tmh0SLvkM1EFAkySjLFzFFBv4=";

<<<<<<< HEAD
  meta = {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    changelog = "https://github.com/solidiquis/erdtree/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "File-tree visualizer and disk usage analyzer";
    homepage = "https://github.com/solidiquis/erdtree";
    changelog = "https://github.com/solidiquis/erdtree/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      zendo
    ];
    mainProgram = "erd";
  };
}

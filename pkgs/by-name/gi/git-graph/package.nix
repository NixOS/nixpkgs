{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-graph";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mlange-42";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xYUpLujePO1MS0c25UJX5rRdmPzkaFgF5zJonzQOJqM=";
  };

  cargoHash = "sha256-y5tVjWj/LczblkL793878vzDG0Gtj3kIo2jZlRA6GJE=";

  meta = with lib; {
    description = "Command line tool to show clear git graphs arranged for your branching model";
    homepage = "https://github.com/mlange-42/git-graph";
    license = licenses.mit;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [
      cafkafk
      matthiasbeyer
    ];
    mainProgram = "git-graph";
  };
}

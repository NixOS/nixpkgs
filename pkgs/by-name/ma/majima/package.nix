{ lib, fetchFromGitLab, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "majima";
  version = "0.4.0";

  src = fetchFromGitLab {
    owner = "gumball-overall";
    repo = "majima";
    rev = version;
    hash = "sha256-S62DQfvZFg8C26YG+fIVJj5cJ6mz73JXSgdu5yoK0Yo=";
  };

  cargoHash = "sha256-zMQO6McnnGbp52A9n/h6yZTU9VH7vak2TSP0HLqDlKw=";

  meta = {
    description = "Generate random usernames quickly and in various formats";
    homepage = "https://majima.matte.fyi/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ufUNnxagpM ];
    mainProgram = "majima";
  };
}

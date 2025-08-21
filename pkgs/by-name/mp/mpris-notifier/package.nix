{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mpris-notifier";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "l1na-forever";
    repo = "mpris-notifier";
    rev = "v${version}";
    hash = "sha256-SD37JFbfg05GemtRNQKvXkXPAyszItSW9wClzudrTS8=";
  };

  cargoHash = "sha256-5LDhxciLpDYd4isUQNx8LF3y7m6cfcuIF2atHj/kayg=";

  meta = with lib; {
    description = "Dependency-light, highly-customizable, XDG desktop notification generator for MPRIS status changes";
    homepage = "https://github.com/l1na-forever/mpris-notifier";
    license = licenses.mit;
    maintainers = with maintainers; [ leixb ];
    mainProgram = "mpris-notifier";
  };
}

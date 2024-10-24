{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "basilk";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "gabalpha";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-b77vVf+WbDNzKwGaMJvgMEMCC41h5TXmg45OM9g4v+4=";
  };

  cargoHash = "sha256-ZYyRUqWbwAoNaGuCXJvqWTgUm5jNpihqvPe5SsfjEq4=";

  meta = with lib; {
    description = "Terminal User Interface (TUI) to manage your tasks with minimal kanban logic";
    homepage = "https://github.com/gabalpha/basilk";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ thtrf ];
    mainProgram = "basilk";
  };
}

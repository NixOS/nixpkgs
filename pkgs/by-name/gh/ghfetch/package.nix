{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ghfetch";
  version = "0.0.19";

  src = fetchFromGitHub {
    owner = "orangekame3";
    repo = "ghfetch";
    rev = "v${version}";
    hash = "sha256-Cmyd/wrobHPyG9ExUSfSsTwFUfbo9iuvmAr0uqunWWw=";
  };

  vendorHash = "sha256-CPh9j5PJOSNvqgq/S9w+Kx3c5yIMHjc1AaqLwz9efeY=";

  meta = with lib; {
    description = "CLI tool to fetch GitHub user information and show like neofetch";
    homepage = "https://github.com/orangekame3/ghfetch";
    license = licenses.mit;
    mainProgram = "ghfetch";
    maintainers = with maintainers; [ aleksana ];
  };
}

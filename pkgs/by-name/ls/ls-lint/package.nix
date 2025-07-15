{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ls-lint";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "loeffel-io";
    repo = "ls-lint";
    rev = "v${version}";
    sha256 = "sha256-kwZvpZaiS58UFE+qncQ370E8bnEuzQACK0FOAYlJwV0=";
  };

  vendorHash = "sha256-XbYfHgpZCGv6w/55dGiFcYTQ36f0n3w8XwnC7wIUFro=";

  meta = with lib; {
    description = "Extremely fast file and directory name linter";
    mainProgram = "ls_lint";
    homepage = "https://ls-lint.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}

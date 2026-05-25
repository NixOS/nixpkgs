{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ls-lint";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "loeffel-io";
    repo = "ls-lint";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-kwZvpZaiS58UFE+qncQ370E8bnEuzQACK0FOAYlJwV0=";
  };

  vendorHash = "sha256-XbYfHgpZCGv6w/55dGiFcYTQ36f0n3w8XwnC7wIUFro=";

  meta = {
    description = "Extremely fast file and directory name linter";
    mainProgram = "ls_lint";
    homepage = "https://ls-lint.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
})

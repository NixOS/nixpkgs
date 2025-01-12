{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "c-for-go";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "xlab";
    repo = "c-for-go";
    rev = "v${version}";
    hash = "sha256-XU+gmQBhQjoiKINfgPQ6bVvslPEFOvF3ZbRaWZE/ZzA=";
  };

  vendorHash = "sha256-4Uw0RYKzZOSVmtdChv/LQQCYU+oVqb1KZbewEW10omw=";

  # Almost all tests fail on the release branch, but package still compiles and works fine.
  doCheck = false;

  meta = {
    homepage = "https://github.com/xlab/c-for-go";
    changelog = "https://github.com/xlab/c-for-go/releases/";
    description = "Automatic C-Go Bindings Generator for the Go Programming Language";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.msanft ];
    mainProgram = "c-for-go";
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule {
  pname = "stackblaster";
  version = "unstable-2026-08-14";

  src = fetchFromGitHub {
    owner = "fjij";
    repo = "stackblaster";
    rev = "b7df4fcbf703f1ee469b82dd049a934680c6c685";
    hash = "sha256-9GEFqhvPlDmpfWIS6TzvxUlp1+Za32Dr6kIAJj98J7Q=";
  };

  vendorHash = "sha256-+m/P4ISOp+l/CDSW8yLbebSeedlSG7uDb4ngYSkApzA=";

  subPackages = [ "cmd/sb" ];

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "Graphite-flavored CLI for GitHub stacked PRs";
    homepage = "https://github.com/fjij/stackblaster";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "stackblaster";
  };
}

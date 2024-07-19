{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "clipse";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    rev = "v${version}";
    hash = "sha256-G26xPABF2Cdxk1N71EaMjKzju0jl5tDJ1WrISjebZVM=";
  };

  vendorHash = "sha256-QEBRlwNS8K44chB3fMOJZxYnIaWMnuDySIhKfF7XtxM=";

  meta = {
    description = "Useful clipboard manager TUI for Unix";
    homepage = "https://github.com/savedra1/clipse";
    license = lib.licenses.mit;
    mainProgram = "clipse";
    maintainers = [ lib.maintainers.savedra1 ];
  };
}

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "clipse";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    rev = "v${version}";
    hash = "sha256-EnT4gnP145FoUysL3L87vY1LrlJoPT1VqDEoH2Fqh2g=";
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

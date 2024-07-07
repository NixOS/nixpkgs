{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "clipse";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    rev = "v${version}";
    hash = "sha256-9r/Ih73eYb45LYOu8HMXqdme/rUwLBI6+gctF603C2w=";
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

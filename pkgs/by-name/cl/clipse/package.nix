{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "clipse";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    rev = "v${version}";
    hash = "sha256-RMdR9d9HdczWstZjDQqJzuWeKv2fAZHfRoy7fJjsJUg=";
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

{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "clipse";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    rev = "v${version}";
    hash = "sha256-DLvYTPlLkp98zCzmbeL68B7mHl7RY3ee9rL30vYm5Ow=";
  };

  vendorHash = "sha256-GIUEx4h3xvLySjBAQKajby2cdH8ioHkv8aPskHN0V+w=";

  meta = {
    description = "Useful clipboard manager TUI for Unix";
    homepage = "https://github.com/savedra1/clipse";
    license = lib.licenses.mit;
    mainProgram = "clipse";
    maintainers = [ lib.maintainers.savedra1 ];
  };
}

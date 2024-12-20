{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "clipse";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "savedra1";
    repo = "clipse";
    rev = "v${version}";
    hash = "sha256-yUkHT7SZT7Eudvk1n43V+WGWqUKtXaV+p4ySMK/XzQw=";
  };

  vendorHash = "sha256-+9uoB/1g4qucdM8RJRs+fSc5hpcgaCK0GrUOFgHWeKo=";

  meta = {
    description = "Useful clipboard manager TUI for Unix";
    homepage = "https://github.com/savedra1/clipse";
    license = lib.licenses.mit;
    mainProgram = "clipse";
    maintainers = [ lib.maintainers.savedra1 ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "lazymake";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "rshelekhov";
    repo = "lazymake";
    tag = "v${version}";
    hash = "sha256-fEAU3ehb4ClsJiKknDcZMik0ux5zyYU+JoAfEpwNUe8=";
  };

  vendorHash = "sha256-X/n7eoughxIP42JcLfifnbyqjYzRQBGsQvvCvFElotY=";

  subPackages = [ "cmd/lazymake" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    description = "Modern TUI for Makefiles with interactive target selection and dependency visualization";
    longDescription = ''
      Lazymake is a terminal UI for browsing and running Makefile targets.
      Features include fuzzy search, execution history, dependency graphs,
      variable inspection, syntax highlighting, safety warnings, and
      performance tracking.
    '';
    homepage = "https://github.com/rshelekhov/lazymake";
    changelog = "https://github.com/rshelekhov/lazymake/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "lazymake";
    platforms = lib.platforms.unix;
  };
}

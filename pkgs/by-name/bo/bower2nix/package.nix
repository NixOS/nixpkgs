{
  buildNpmPackage,
  fetchFromGitHub,
  git,
  lib,
  nix,
  unstableGitUpdater,
}:

buildNpmPackage rec {
  pname = "bower2nix";
  version = "3.2.0-unstable-2024-06-25";

  src = fetchFromGitHub {
    owner = "rvl";
    repo = "bower2nix";
    rev = "b5da44f055c7561ed7a46226b3be0070e07d80e6";
    hash = "sha256-da+m2UWQ83tW1o0P1qvw35KpsXL/BDTeShg4KxL+7Ck=";
  };

  npmDepsHash = "sha256-TK1sqF2J/hQuP3bgGA4MolLA7LWWuYNnqf4gDyU154k=";

  npmBuildScript = "prepare";

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        git
        nix
      ]
    }"
  ];

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    changelog = "https://github.com/rvl/bower2nix/releases/tag/v${version}";
    description = "Generate nix expressions to fetch bower dependencies";
    homepage = "https://github.com/rvl/bower2nix";
    license = lib.licenses.gpl3Only;
    mainProgram = "bower2nix";
    maintainers = [ ];
  };
}

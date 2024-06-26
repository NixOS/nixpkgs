{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "arrpc";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "OpenAsar";
    repo = "arrpc";
    # Release commits are not tagged
    # release: 3.4.0
    rev = "cca93db585dedf8acc1423f5e2db215de95c4c3b";
    hash = "sha256-SeegrCgbjfVxG/9xfOcdfbVdDssZOhjBRnDipu6L7Wg=";
  };

  npmDepsHash = "sha256-S9cIyTXqCp8++Yj3VjBbcStOjzjgd0Cq7KL7NNzZFpY=";

  dontNpmBuild = true;

  meta = {
    # ideally we would do blob/${version}/changelog.md here
    # upstream does not tag releases
    changelog = "https://github.com/OpenAsar/arrpc/blob/${src.rev}/changelog.md";
    description = "Open Discord RPC server for atypical setups";
    homepage = "https://arrpc.openasar.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anomalocaris
      NotAShelf
    ];
    mainProgram = "arrpc";
  };
}

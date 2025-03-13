{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  git,
}:
buildDotnetModule rec {
  pname = "min-ed-launcher";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "rfvgyhn";
    repo = "min-ed-launcher";
    tag = "v${version}";
    hash = "sha256-ur1stk5dzdf8FgjGFCVEcNgBDdfYl7Iy7OjwabxV9X8=";

    leaveDotGit = true;
  };

  projectFile = "MinEdLauncher.sln";
  nugetDeps = ./deps.json;
  buildInputs = [
    git
  ];

  executables = [ "MinEdLauncher" ];

  meta = {
    homepage = "https://github.com/rfvgyhn/min-ed-launcher";
    description = "Minimal Elite Dangerous Launcher";
    license = lib.licenses.mit;
    platforms = lib.platforms.x86_64;
    mainProgram = "MinEdLauncher";
    maintainers = with lib.maintainers; [ jiriks74 ];
  };
}

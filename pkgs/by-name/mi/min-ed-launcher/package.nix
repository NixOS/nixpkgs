{
  lib,
  buildDotnetModule,
  dotnet-sdk_10,
  dotnet-runtime_10,
  fetchFromGitHub,
  git,
}:
buildDotnetModule rec {
  pname = "min-ed-launcher";
  version = "0.14.0";

  dotnet-sdk = dotnet-sdk_10;
  dotnet-runtime = dotnet-runtime_10;

  src = fetchFromGitHub {
    owner = "rfvgyhn";
    repo = "min-ed-launcher";
    tag = "v${version}";
    hash = "sha256-1vSZ2DWzqPdxiake9FkpZhB/hi/xnIf+npaHV+yazCI=";

    leaveDotGit = true; # During build the current commit is appended to the version
  };

  projectFile = "MinEdLauncher.sln";
  nugetDeps = ./deps.json;
  buildInputs = [
    git # During build the current commit is appended to the version
  ];

  postPatch = ''
    substituteInPlace global.json \
      --replace-fail '10.0.402' '10.0.401'
  '';

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

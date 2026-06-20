{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "gh-gei";
  version = "1.30.1";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-gei";
    rev = "v${version}";
    hash = "sha256-eccHFngmP0uUsbtlFSIT1agRMx3OCNyqPMHG8/mj5P8=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0_4xx;
  projectFile = "src/gei/gei.csproj";
  nugetDeps = ./deps.json; # File generated with `nix-build -A gh-gei.passthru.fetch-deps`.

  meta = {
    homepage = "https://github.com/github/gh-gei";
    description = "Migration CLI for GitHub to GitHub migrations";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lafrenierejm ];
    mainProgram = "gei";
  };
}

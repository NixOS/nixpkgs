{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "gh-gei";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-gei";
    rev = "v${version}";
    hash = "sha256-5BGYNhrHtRHtjfdjSodlhc0Yu/GcYXjvdzGBg2AWVzc=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0_4xx;
  projectFile = "src/gei/gei.csproj";
  nugetDeps = ./deps.json; # File generated with `nix-build -A gh-gei.passthru.fetch-deps`.

  meta = with lib; {
    homepage = "https://github.com/github/gh-gei";
    description = "Migration CLI for GitHub to GitHub migrations";
    license = licenses.mit;
    maintainers = with maintainers; [ lafrenierejm ];
    mainProgram = "gei";
  };
}

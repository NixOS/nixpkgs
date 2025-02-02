{ lib
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "gh-gei";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-F1sxT9wh/K6VP7n1SlmmvmHlcgxDJw6Rht2hPIiRFjE=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  projectFile = "src/gei/gei.csproj";
  nugetDeps = ./deps.nix; # File generated with `nix-build -A gh-gei.passthru.fetch-deps`.

  meta = with lib; {
    homepage = "https://github.com/github/gh-gei";
    description = "Migration CLI for GitHub to GitHub migrations";
    license = licenses.mit;
    maintainers = with maintainers; [ lafrenierejm ];
    mainProgram = "gei";
  };
}

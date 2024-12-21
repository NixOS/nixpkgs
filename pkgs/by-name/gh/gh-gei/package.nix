{ lib
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "gh-gei";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hUURXPKhiI3n1BrW8IzVVmPuJyO4AxM8D5uluaJXk+4=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
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

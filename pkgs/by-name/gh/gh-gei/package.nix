{ lib
, fetchFromGitHub
, buildDotnetModule
}:

buildDotnetModule rec {
  pname = "gh-gei";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cz301JzGZTAu0DcxmFpEmBemEij1+OIw4dB2PpwyYS0=";
  };

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

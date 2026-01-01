{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "gh-gei";
<<<<<<< HEAD
  version = "1.23.0";
=======
  version = "1.21.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-gei";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-9sTyxLs5ug1fKh2qvKkuhA9r0cmfdaPT+pWuc6hxyN4=";
=======
    hash = "sha256-hlhryJno8XpSITBv1ShhqP7jPoRtoscD/YGXIU6ubt0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0_4xx;
  projectFile = "src/gei/gei.csproj";
  nugetDeps = ./deps.json; # File generated with `nix-build -A gh-gei.passthru.fetch-deps`.

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/github/gh-gei";
    description = "Migration CLI for GitHub to GitHub migrations";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lafrenierejm ];
=======
  meta = with lib; {
    homepage = "https://github.com/github/gh-gei";
    description = "Migration CLI for GitHub to GitHub migrations";
    license = licenses.mit;
    maintainers = with maintainers; [ lafrenierejm ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gei";
  };
}

{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages }:

buildDotnetModule rec {
  pname = "nbxplorer";
  version = "2.3.26";

  src = fetchFromGitHub {
    owner = "dgarage";
    repo = "NBXplorer";
    rev = "v${version}";
    sha256 = "sha256-PaunSwbIf9hGmZeS8ZI4M0C6T76bLCalnS4/x9TWrtY=";
  };

  projectFile = "NBXplorer/NBXplorer.csproj";
  nugetDeps = ./deps.nix;

  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

  postFixup = ''
    mv $out/bin/{NBXplorer,nbxplorer}
  '';

  meta = with lib; {
    description = "Minimalist UTXO tracker for HD Cryptocurrency Wallets";
    maintainers = with maintainers; [ kcalvinalvin erikarvstedt ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

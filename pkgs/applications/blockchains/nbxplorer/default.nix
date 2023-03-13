{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "nbxplorer";
  version = "2.3.62";

  src = fetchFromGitHub {
    owner = "dgarage";
    repo = "NBXplorer";
    rev = "v${version}";
    sha256 = "sha256-FpAMkVgvl0SxJ59FjL4H3Fvqb1LKsET2I+A01TQlvFA=";
  };

  projectFile = "NBXplorer/NBXplorer.csproj";
  nugetDeps = ./deps.nix;

  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

  # macOS has a case-insensitive filesystem, so these two can be the same file
  postFixup = ''
    mv $out/bin/{NBXplorer,nbxplorer} || :
  '';

  meta = with lib; {
    description = "Minimalist UTXO tracker for HD Cryptocurrency Wallets";
    maintainers = with maintainers; [ kcalvinalvin erikarvstedt ];
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}

{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "nbxplorer";
  version = "2.3.57";

  src = fetchFromGitHub {
    owner = "dgarage";
    repo = "NBXplorer";
    rev = "v${version}";
    sha256 = "sha256-oLkkGdzjyvgIXi0HZiFPCShzbBR8cOgMf1h1Nf1U6Rk=";
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

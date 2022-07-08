{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, altcoinSupport ? false }:

buildDotnetModule rec {
  pname = "btcpayserver";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SUII1R70MIc5A4hpQRwCoSZuthLPXl+67IUU6cDyfRI=";
  };

  projectFile = "BTCPayServer/BTCPayServer.csproj";
  nugetDeps = ./deps.nix;

  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

  buildType = if altcoinSupport then "Altcoins-Release" else "Release";

  # darwin uses case-insensitive filesystem so these two can be the same file
  postFixup = ''
    mv $out/bin/{BTCPayServer,btcpayserver} || :
  '';

  meta = with lib; {
    description = "Self-hosted, open-source cryptocurrency payment processor";
    homepage = "https://btcpayserver.org";
    maintainers = with maintainers; [ kcalvinalvin erikarvstedt ];
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}

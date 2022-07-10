{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages
, altcoinSupport ? false }:

buildDotnetModule rec {
  pname = "btcpayserver";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8GMk7xBMhml0X/8YRuN3FsEF2TWDxtb0eoP/cduKXNg=";
  };

  projectFile = "BTCPayServer/BTCPayServer.csproj";
  nugetDeps = ./deps.nix;

  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

  buildType = if altcoinSupport then "Altcoins-Release" else "Release";

  postFixup = ''
    mv $out/bin/{BTCPayServer,btcpayserver}
  '';

  meta = with lib; {
    description = "Self-hosted, open-source cryptocurrency payment processor";
    homepage = "https://btcpayserver.org";
    maintainers = with maintainers; [ kcalvinalvin erikarvstedt ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

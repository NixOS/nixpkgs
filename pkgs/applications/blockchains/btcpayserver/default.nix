{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages
, altcoinSupport ? false }:

buildDotnetModule rec {
  pname = "btcpayserver";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DcxRrVUen+JxMpiLDPfknpwCe962ifaekBeBnxJ0y88=";
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
    maintainers = with maintainers; [ kcalvinalvin earvstedt ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

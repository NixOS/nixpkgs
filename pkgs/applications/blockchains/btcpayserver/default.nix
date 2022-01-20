{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages
, altcoinSupport ? false }:

buildDotnetModule rec {
  pname = "btcpayserver";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W8WRw42hMNUaQZlfrl73REGIvLcj6Vso9Axx53ENkx0=";
  };

  projectFile = "BTCPayServer/BTCPayServer.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  dotnet-runtime = dotnetCorePackages.aspnetcore_3_1;

  dotnetFlags = lib.optionals altcoinSupport [ "/p:Configuration=Altcoins-Release" ];

  # btcpayserver requires the publish directory as its working dir
  # https://github.com/btcpayserver/btcpayserver/issues/1894
  preInstall = ''
    makeWrapperArgs+=(--run "cd $out/lib/btcpayserver")
  '';

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

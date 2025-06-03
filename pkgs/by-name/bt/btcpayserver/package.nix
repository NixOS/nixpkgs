{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  altcoinSupport ? false,
}:

buildDotnetModule rec {
  pname = "btcpayserver";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "btcpayserver";
    repo = "btcpayserver";
    tag = "v${version}";
    hash = "sha256-5zvxLEQbKTcslcpq1JRgY/L0XWnQ4UyFWww6SGcTtcs=";
  };

  projectFile = "BTCPayServer/BTCPayServer.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  buildType = if altcoinSupport then "Altcoins-Release" else "Release";

  # macOS has a case-insensitive filesystem, so these two can be the same file
  postFixup = ''
    mv $out/bin/{BTCPayServer,btcpayserver} || :
  '';

  meta = with lib; {
    description = "Self-hosted, open-source cryptocurrency payment processor";
    homepage = "https://btcpayserver.org";
    changelog = "https://github.com/btcpayserver/btcpayserver/blob/v${version}/Changelog.md";
    maintainers = with maintainers; [
      kcalvinalvin
      erikarvstedt
    ];
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}

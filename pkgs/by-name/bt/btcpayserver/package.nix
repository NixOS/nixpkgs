{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  altcoinSupport ? false,
}:

buildDotnetModule rec {
  pname = "btcpayserver";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "btcpayserver";
    repo = "btcpayserver";
    tag = "v${version}";
    hash = "sha256-u4VNDKLOb6bEkdhRTmnGxyM+2a6mcdWwV1T4+HFK/14=";
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

  meta = {
    description = "Self-hosted, open-source cryptocurrency payment processor";
    homepage = "https://btcpayserver.org";
    changelog = "https://github.com/btcpayserver/btcpayserver/blob/v${version}/Changelog.md";
    maintainers = with lib.maintainers; [
      kcalvinalvin
      erikarvstedt
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

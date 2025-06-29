{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  altcoinSupport ? false,
}:

buildDotnetModule rec {
  pname = "btcpayserver";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "btcpayserver";
    repo = "btcpayserver";
    tag = "v${version}";
    hash = "sha256-qm/MdgM5sPQu7fI1S8qf/dvkMZbmP4rLA1RdSQHSawE=";
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

{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "nbxplorer";
  version = "2.6.10";

  src = fetchFromGitHub {
    owner = "btcpayserver";
    repo = "NBXplorer";
    tag = "v${version}";
    hash = "sha256-bAAEB1wIaWgDygk79bCuvkNDiPvgsUhVDqIrR3LMp7Q=";
  };

  projectFile = "NBXplorer/NBXplorer.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  # macOS has a case-insensitive filesystem, so these two can be the same file
  postFixup = ''
    mv $out/bin/{NBXplorer,nbxplorer} || :
  '';

  meta = {
    description = "Minimalist UTXO tracker for HD Cryptocurrency Wallets";
    homepage = "https://github.com/btcpayserver/NBXplorer";
    maintainers = with lib.maintainers; [
      kcalvinalvin
      erikarvstedt
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "nbxplorer";
  };
}

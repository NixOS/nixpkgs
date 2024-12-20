{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "nbxplorer";
  version = "2.5.16";

  src = fetchFromGitHub {
    owner = "dgarage";
    repo = "NBXplorer";
    rev = "v${version}";
    sha256 = "sha256-4hhnw7NNqJ4Q3UPqDlw5X/R0yGlte7YwWd9lpX0n8Fo=";
  };

  projectFile = "NBXplorer/NBXplorer.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  # macOS has a case-insensitive filesystem, so these two can be the same file
  postFixup = ''
    mv $out/bin/{NBXplorer,nbxplorer} || :
  '';

  meta = with lib; {
    description = "Minimalist UTXO tracker for HD Cryptocurrency Wallets";
    maintainers = with maintainers; [
      kcalvinalvin
      erikarvstedt
    ];
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "nbxplorer";
  };
}

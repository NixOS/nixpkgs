{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  autoPatchelfHook,
  zlib,
  openssl,
}:
buildDotnetModule rec {
  pname = "wasabibackend";
  version = "2.0.2.1";

  src = fetchFromGitHub {
    owner = "zkSNACKs";
    repo = "WalletWasabi";
    rev = "refs/tags/v${version}";
    hash = "sha512-JuCl3SyejzwUd2n8Fy7EdxUuO4bIcGb8yMWZQOhZzsY4fvg9prFOnVZEquxahD0a41MLKHRNA1R2N3NMapcc0A==";
  };

  projectFile = "WalletWasabi.Backend/WalletWasabi.Backend.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_7_0;

  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [stdenv.cc.cc.lib zlib];

  runtimeDeps = [openssl zlib];

  preConfigure = ''
    makeWrapperArgs+=(
      --chdir "$out/lib/${pname}"
    )
  '';

  postFixup = ''
    mv $out/bin/WalletWasabi.Backend $out/bin/WasabiBackend
  '';

  meta = with lib; {
    description = "Backend for the Wasabi Wallet";
    homepage = "https://wasabiwallet.io/";
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    license = licenses.mit;
    maintainers = with maintainers; [mmahut];
    platforms = ["x86_64-linux"];
  };
}

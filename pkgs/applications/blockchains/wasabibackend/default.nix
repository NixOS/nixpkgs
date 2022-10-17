{ lib
, stdenv
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
, autoPatchelfHook
, zlib
, openssl
}:

buildDotnetModule rec {
  pname = "wasabibackend";
  version = "1.1.13.1";

  src = fetchFromGitHub {
    owner = "zkSNACKs";
    repo = "WalletWasabi";
    rev = "v${version}";
    sha256 = "sha256-Hwav7moG6XKAcR7L0Q7CtifP3zCNRfHIihlaFw+dzbk=";
  };

  projectFile = "WalletWasabi.Backend/WalletWasabi.Backend.csproj";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  dotnet-runtime = dotnetCorePackages.aspnetcore_3_1;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib zlib ];

  runtimeDeps = [ openssl zlib ];

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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
    platforms = [ "x86_64-linux" ];
  };
}

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
  version = "1.1.13.0";

  src = fetchFromGitHub {
    owner = "zkSNACKs";
    repo = "WalletWasabi";
    rev = "v${version}";
    sha256 = "sha256-zDOk8MurT5NXOr4kvm5mnsphY+eDFWuVBcpeTZpcHOo=";
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
      --run "cd $out/lib/${pname}"
    )
  '';

  postFixup = ''
    mv $out/bin/WalletWasabi.Backend $out/bin/WasabiBackend
  '';

  meta = with lib; {
    description = "Backend for the Wasabi Wallet";
    homepage = "https://wasabiwallet.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
    platforms = [ "x86_64-linux" ];
  };
}

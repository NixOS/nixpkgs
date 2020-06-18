{ stdenv
, fetchFromGitHub
, fetchurl
, makeWrapper
, Nuget
, dotnetCorePackages
, openssl
, zlib
}:

let
  deps = import ./deps.nix { inherit fetchurl; };

  dotnet-sdk = dotnetCorePackages.sdk_3_1;
  dotnet-aspnetcore = dotnetCorePackages.aspnetcore_3_1;

  nugetSource = stdenv.mkDerivation {
    pname = "${pname}-nuget-deps";
    inherit version;

    dontUnpack = true;
    dontInstall = true;

    nativeBuildInputs = [ Nuget ];

    buildPhase = ''
      export HOME=$(mktemp -d)
      mkdir -p $out/lib

      nuget sources Disable -Name "nuget.org"
      for package in ${toString deps}; do
        nuget add $package -Source $out/lib
      done
    '';
  };

  pname = "WasabiBackend";
  version = "1.1.11.1";

  projectName = "WalletWasabi.Backend";
  projectConfiguration = "Release";
  projectRuntime = "linux-x64";
in

stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zkSNACKs";
    repo = "WalletWasabi";
    rev = "v${version}";
    sha256 = "0kxww8ywhld00b0qsv5jh5s19jqpahnb9mvshmjnp3cb840j12a7";
  };

  buildInputs = [
    Nuget
    dotnet-sdk
    makeWrapper
  ];

  buildPhase = ''
    export HOME=$(mktemp -d)
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
    export DOTNET_ROOT="${dotnet-sdk}/bin"

    nuget sources Disable -Name "nuget.org"

    dotnet restore \
      --source ${nugetSource}/lib \
      --runtime ${projectRuntime} \
      ${projectName}

    dotnet publish \
      --no-restore \
      --runtime ${projectRuntime} \
      --configuration ${projectConfiguration} \
      ${projectName}
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ${projectName}/bin/${projectConfiguration}/netcoreapp3.1/${projectRuntime}/publish $out/lib
    mkdir -p $out/bin
    makeWrapper $out/lib/WalletWasabi.Backend $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ openssl zlib ]} \
      --run "cd $out/lib"
  '';

  # If we don't disable stripping the executable fails to start with segfault
  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Backend for the Wasabi Wallet";
    homepage = "https://wasabiwallet.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
    platforms = [ "x86_64-linux" ];
  };
}

{ lib, stdenv, fetchFromGitHub, fetchurl, linkFarmFromDrvs, makeWrapper,
  dotnetPackages, dotnetCorePackages, altcoinSupport ? false
}:

let
  deps = import ./deps.nix {
    fetchNuGet = { name, version, sha256 }: fetchurl {
      name = "nuget-${name}-${version}.nupkg";
      url = "https://www.nuget.org/api/v2/package/${name}/${version}";
      inherit sha256;
    };
  };
  dotnetSdk = dotnetCorePackages.sdk_3_1;
in

stdenv.mkDerivation rec {
  pname = "btcpayserver";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6ktlnbYb+pOXwl52QmnqDsPlXaiF1ghjQg1yfznulqo=";
  };

  nativeBuildInputs = [ dotnetSdk dotnetPackages.Nuget makeWrapper ];

  buildPhase = ''
    export HOME=$TMP/home
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

    nuget sources Add -Name tmpsrc -Source $TMP/nuget
    nuget init ${linkFarmFromDrvs "deps" deps} $TMP/nuget

    dotnet restore --source $TMP/nuget ${lib.optionalString altcoinSupport ''/p:Configuration="Altcoins-Release"''} BTCPayServer/BTCPayServer.csproj
    dotnet publish --no-restore --output $out/share/$pname ${lib.optionalString altcoinSupport "-c Altcoins-Release"} BTCPayServer/BTCPayServer.csproj
  '';

  # btcpayserver requires the publish directory as its working dir
  # https://github.com/btcpayserver/btcpayserver/issues/1894
  installPhase = ''
    makeWrapper $out/share/$pname/BTCPayServer $out/bin/$pname \
      --set DOTNET_ROOT "${dotnetSdk}" \
      --run "cd $out/share/$pname"
  '';

  dontStrip = true;

  meta = with lib; {
    description = "Self-hosted, open-source cryptocurrency payment processor";
    homepage = "https://btcpayserver.org";
    maintainers = with maintainers; [ kcalvinalvin earvstedt ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}

{ lib, stdenv, fetchFromGitHub, fetchurl, linkFarmFromDrvs, makeWrapper,
  dotnetPackages, dotnetCorePackages, writeScript, bash
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
  version = "1.0.5.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "11h1nrmb7f44msbhhiz9ddqh5ss2kz6d8ysnvd070x3xj5krgnxz";
  };

  nativeBuildInputs = [ dotnetSdk dotnetPackages.Nuget ];

  # Due to a bug in btcpayserver, we can't just `dotnet publish` to create a binary.
  # Build with `dotnet build` instead and add a custom `dotnet run` script.
  buildPhase = ''
    export HOME=$TMP/home
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

    nuget sources Add -Name tmpsrc -Source $TMP/nuget
    nuget init ${linkFarmFromDrvs "deps" deps} $TMP/nuget

    dotnet restore --source $TMP/nuget BTCPayServer/BTCPayServer.csproj
    dotnet build -c Release BTCPayServer/BTCPayServer.csproj
  '';

  runScript =  ''
    #!${bash}/bin/bash
    DOTNET_CLI_TELEMETRY_OPTOUT=1 exec ${dotnetSdk}/bin/dotnet run --no-launch-profile --no-build \
      -c Release -p @@SHARE@@/BTCPayServer/BTCPayServer.csproj -- "$@"
  '';

  installPhase = ''
    cd ..
    share=$out/share/$pname
    mkdir -p $share
    mv -T source $share
    install -D -m500 <(echo "$runScript" | sed "s|@@SHARE@@|$share|") $out/bin/$pname
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

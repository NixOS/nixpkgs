{ stdenv, fetchurl, unzip, makeWrapper, dotnetCorePackages, jq }:

stdenv.mkDerivation rec {
  pname = "ArchiSteamFarm";
  version = "4.2.3.6";

  src = fetchurl {
    url = "https://github.com/JustArchiNET/ArchiSteamFarm/releases/download/${version}/ASF-generic.zip";
    sha256 = "1a8baxrb8czndxxi16md1nyl2snfx215yvrygdpcblgngkp2z2y9";
  };

  nativeBuildInputs = [ unzip makeWrapper jq ];

  sourceRoot = ".";

  installPhase = ''
    dist=$out/opt/asf
    mkdir -p $dist
    cp -r * $dist

    jq "del(.runtimeOptions.framework.version)" ArchiSteamFarm.runtimeconfig.json > $dist/ArchiSteamFarm.runtimeconfig.json

    makeWrapper ${dotnetCorePackages.aspnetcore_3_1}/bin/dotnet $out/bin/ArchiSteamFarm \
      --add-flags $dist/ArchiSteamFarm.dll \
      --add-flags "--path ~/.config/asf" \
      --run "mkdir -p ~/.config/asf" \
      --run "cd ~/.config/asf" \
      --run "[ -d config ] || cp --no-preserve=mode -r $dist/config ." \
      --run "[ -d logs ] || cp --no-preserve=mode -r $dist/logs ." \
      --run "[ -d plugins ] || cp --no-preserve=mode -r $dist/plugins ." \
      --run "ln -sf $dist/www ."
  '';

  meta = with stdenv.lib; {
    description = "Application with primary purpose of idling Steam cards from multiple accounts simultaneously";
    homepage = "https://github.com/JustArchiNET/ArchiSteamFarm";
    license = licenses.asl20;
    platforms = dotnetCorePackages.aspnetcore_3_1.meta.platforms;
    maintainers = with maintainers; [ gnidorah ];
    hydraPlatforms = [];
  };
}

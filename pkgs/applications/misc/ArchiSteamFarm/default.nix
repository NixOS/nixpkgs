{ stdenv, fetchurl, unzip, makeWrapper, autoPatchelfHook
, zlib, lttng-ust, curl, icu, openssl }:

stdenv.mkDerivation rec {
  pname = "ArchiSteamFarm";
  version = "4.2.0.6";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/JustArchiNET/ArchiSteamFarm/releases/download/${version}/ASF-linux-x64.zip";
      sha256 = "05hx6q1lkbjbqhwi9xxvm7ycnsnpl1cnqzyy2yn0q4x27im399cn";
    };
    armv7l-linux = fetchurl {
      url = "https://github.com/JustArchiNET/ArchiSteamFarm/releases/download/${version}/ASF-linux-arm.zip";
      sha256 = "0l8irqrpl5vbjj84k4makj2ph2z6kpny7qz51zrzbgwhrlw0w4vg";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/JustArchiNET/ArchiSteamFarm/releases/download/${version}/ASF-linux-arm64.zip";
      sha256 = "0hg2g4i8sj3fxqfy4imz1iarby1d9f8dh59j266lbbdf2vfz2cml";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");

  nativeBuildInputs = [ unzip makeWrapper autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc zlib lttng-ust curl ];

  sourceRoot = ".";

  installPhase = ''
    dist=$out/opt/asf
    mkdir -p $dist
    cp -r * $dist
    chmod +x $dist/ArchiSteamFarm
    makeWrapper $dist/ArchiSteamFarm $out/bin/ArchiSteamFarm \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ icu openssl ] }" \
      --add-flags "--path ~/.config/asf" \
      --run "mkdir -p ~/.config/asf" \
      --run "cd ~/.config/asf" \
      --run "[ -d config ] || cp --no-preserve=mode -r $dist/config ." \
      --run "[ -d logs ] || cp --no-preserve=mode -r $dist/logs ." \
      --run "[ -d plugins ] || cp --no-preserve=mode -r $dist/plugins ." \
      --run "[ -d www ] || cp --no-preserve=mode -r $dist/www ." \
  '';

  meta = with stdenv.lib; {
    description = "Application with primary purpose of idling Steam cards from multiple accounts simultaneously";
    homepage = "https://github.com/JustArchiNET/ArchiSteamFarm";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ gnidorah ];
    hydraPlatforms = [];
  };
}

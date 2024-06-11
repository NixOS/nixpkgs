{ lib
, stdenv
, fetchurl
, makeWrapper
, libX11
, libXext
, libXrandr
, freetype
, fontconfig
, libXrender
, libXinerama
, autoPatchelfHook
, libglvnd
, openal
, imagemagick
, makeDesktopItem
}:
let
  version = "4.0";

  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "x64"
    else if stdenv.hostPlatform.system == "i686-linux" then
      "x86"
    else
      throw "Unsupported platform ${stdenv.hostPlatform.system}";

  desktopItem = makeDesktopItem {
    name = "Heaven";
    exec = "heaven";
    genericName = "A GPU Stress test tool from the UNIGINE";
    icon = "Heaven";
    desktopName = "Heaven Benchmark";
  };
in
stdenv.mkDerivation
{
  pname = "unigine-heaven";
  inherit version;

  src = fetchurl {
    url = "https://assets.unigine.com/d/Unigine_Heaven-${version}.run";
    sha256 = "19rndwwxnb9k2nw9h004hyrmr419471s0fp25yzvvc6rkd521c0v";
  };

  installPhase =
    ''
      sh $src --target $name

      mkdir -p $out/lib/unigine/heaven/bin
      mkdir -p $out/bin
      mkdir -p $out/share/applications/
      mkdir -p $out/share/icons/hicolor

      install -m 0755 $name/bin/browser_${arch} $out/lib/unigine/heaven/bin
      install -m 0755 $name/bin/libApp{Stereo,Surround,Wall}_${arch}.so $out/lib/unigine/heaven/bin
      install -m 0755 $name/bin/libGPUMonitor_${arch}.so $out/lib/unigine/heaven/bin
      install -m 0755 $name/bin/libQt{Core,Gui,Network,WebKit,Xml}Unigine_${arch}.so.4 $out/lib/unigine/heaven/bin
      install -m 0755 $name/bin/libUnigine_${arch}.so $out/lib/unigine/heaven/bin
      install -m 0755 $name/bin/heaven_${arch} $out/lib/unigine/heaven/bin
      install -m 0755 $name/heaven $out/bin/heaven

      cp -R $name/data $name/documentation $out/lib/unigine/heaven

      wrapProgram $out/bin/heaven --prefix LD_LIBRARY_PATH : ${libglvnd}/lib:$out/bin:${openal}/lib --run "cd $out/lib/unigine/heaven/"

      convert $out/lib/unigine/heaven/data/launcher/icon.png -resize 128x128 $out/share/icons/Heaven.png
      for RES in 16 24 32 48 64 128 256
      do
          mkdir -p $out/share/icons/hicolor/"$RES"x"$RES"/apps
          convert $out/lib/unigine/heaven/data/launcher/icon.png -resize "$RES"x"$RES" $out/share/icons/hicolor/"$RES"x"$RES"/apps/Heaven.png
      done

      ln -s ${desktopItem}/share/applications/* $out/share/applications
    '';

  nativeBuildInputs =
    [
      autoPatchelfHook
      makeWrapper
      imagemagick
    ];

  buildInputs =
    [
      libX11
      stdenv.cc.cc
      libXext
      libXrandr
      freetype
      fontconfig
      libXrender
      libXinerama
    ];

  dontUnpack = true;

  meta =
    {
      description = "Unigine Heaven GPU benchmarking tool";
      homepage = "https://benchmark.unigine.com/heaven";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      maintainers = [ lib.maintainers.BarinovMaxim ];
      platforms = [ "x86_64-linux" "i686-linux" ];
    };
}

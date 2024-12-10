{
  lib,
  stdenv,
  fetchurl,

  # Build-time dependencies
  makeWrapper,
  file,
  makeDesktopItem,
  imagemagick,
  copyDesktopItems,

  # Runtime dependencies
  fontconfig,
  freetype,
  libX11,
  libXext,
  libXinerama,
  libXrandr,
  libXrender,
  libglvnd,
  openal,
}:

let
  version = "1.0";

  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "x64"
    else if stdenv.hostPlatform.system == "i686-linux" then
      "x86"
    else
      throw "Unsupported platform ${stdenv.hostPlatform.system}";
in

stdenv.mkDerivation rec {
  pname = "unigine-valley";
  inherit version;

  src = fetchurl {
    url = "https://assets.unigine.com/d/Unigine_Valley-${version}.run";
    sha256 = "sha256-XwyL0kMRGFURgrq79fHCD7FOekB4lpckDcr1RkQ2YPQ=";
  };

  sourceRoot = "Unigine_Valley-${version}";
  instPath = "lib/unigine/valley";

  nativeBuildInputs = [
    file
    makeWrapper
    imagemagick
    copyDesktopItems
  ];

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc # libstdc++.so.6
    fontconfig
    freetype
    libX11
    libXext
    libXinerama
    libXrandr
    libXrender
    libglvnd
    openal
  ];

  unpackPhase = ''
    runHook preUnpack

    cp $src extractor.run
    chmod +x extractor.run
    ./extractor.run --target $sourceRoot

    runHook postUnpack
  '';

  postPatch = ''
    # Patch ELF files.
    elfs=$(find bin -type f | xargs file | grep ELF | cut -d ':' -f 1)
    for elf in $elfs; do
      patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 $elf || true
    done
  '';

  installPhase = ''
    runHook preInstall

    instdir=$out/${instPath}
    mkdir -p $out/share/icons/hicolor $out/share/applications $out/bin $instdir/bin

    # Install executables and libraries
    install -m 0755 bin/browser_${arch} $instdir/bin
    install -m 0755 bin/libApp{Stereo,Surround,Wall}_${arch}.so $instdir/bin
    install -m 0755 bin/libGPUMonitor_${arch}.so $instdir/bin
    install -m 0755 bin/libQt{Core,Gui,Network,WebKit,Xml}Unigine_${arch}.so.4 $instdir/bin
    install -m 0755 bin/libUnigine_${arch}.so $instdir/bin
    install -m 0755 bin/valley_${arch} $instdir/bin
    install -m 0755 valley $instdir
    install -m 0755 valley $out/bin/valley

    # Install other files
    cp -R data documentation $instdir

    # Install and wrap executable
    wrapProgram $out/bin/valley \
      --chdir "$instdir" \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:$instdir/bin:$libPath

    # Make desktop Icon
    convert $out/lib/unigine/valley/data/launcher/icon.png -resize 128x128 $out/share/icons/Valley.png
    for RES in 16 24 32 48 64 128 256
    do
        mkdir -p $out/share/icons/hicolor/"$RES"x"$RES"/apps
        convert $out/lib/unigine/valley/data/launcher/icon.png -resize "$RES"x"$RES" $out/share/icons/hicolor/"$RES"x"$RES"/apps/Valley.png
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Valley";
      exec = "valley";
      genericName = "A GPU Stress test tool from the UNIGINE";
      icon = "Valley";
      desktopName = "Valley Benchmark";
    })
  ];

  stripDebugList = [ "${instPath}/bin" ];

  meta = {
    description = "The Unigine Valley GPU benchmarking tool";
    homepage = "https://unigine.com/products/benchmarks/valley/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree; # see also: $out/$instPath/documentation/License.pdf
    maintainers = [ lib.maintainers.kierdavis ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    mainProgram = "valley";
  };
}

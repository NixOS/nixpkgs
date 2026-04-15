{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  buildFHSEnv,
  alsa-lib,
  alsa-plugins,
  freetype,
  nghttp2,
  libx11,
  expat,
}:

stdenv.mkDerivation rec {
  pname = "decent-sampler";
  version = "1.18.1";

  src = fetchzip {
    # Download page: https://store.decentsamples.com/downloads/decent-sampler/versions
    url = "https://cdn.decentsamples.com/production/builds/ds/${version}/Decent_Sampler-${version}-Linux-Static-x86_64.tar.gz";
    hash = "sha256-wL9L4I2iw9r3r69TOr37XXEs3iECMuNGX9Ez63P/f8w=";
  };

  icon = fetchurl {
    url = "https://www.decentsamples.com/wp-content/uploads/2018/09/cropped-Favicon_512x512.png";
    hash = "sha256-EXjaHrlXY0HU2EGTrActNbltIiqTLfdkFgP7FXoLzrM=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "decent-sampler";
      desktopName = "Decent Sampler";
      comment = "DecentSampler player";
      icon = "decent-sampler";
      exec = "decent-sampler";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  fhsEnv = buildFHSEnv {
    pname = "${pname}-fhs-env";
    inherit version;

    runScript = "";

    targetPkgs = pkgs: [
      alsa-lib
      alsa-plugins
      freetype
      nghttp2
      libx11
      expat
    ];
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/vst $out/lib/vst3 $out/share/icons/hicolor/512x512/apps

    install -Dm755 DecentSampler $out/libexec/decent-sampler
    install -Dm755 DecentSampler.so -t $out/lib/vst
    cp -r DecentSampler.vst3 $out/lib/vst3
    install -Dm444 ${icon} $out/share/icons/hicolor/512x512/apps/decent-sampler.png

    # Wrapper to run inside FHS env
    makeWrapper ${fhsEnv}/bin/${pname}-fhs-env $out/bin/decent-sampler \
      --add-flags $out/libexec/decent-sampler \
      --argv0 decent-sampler

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Audio sample player";
    longDescription = ''
      Decent Sampler is an audio sample player.
      Allowing you to play sample libraries in the DecentSampler format
      (files with extensions: dspreset and dslibrary).
    '';
    mainProgram = "decent-sampler";
    homepage = "https://www.decentsamples.com/product/decent-sampler-plugin/";
    # It claims to be free but we currently cannot find any license
    # that it is released under.
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      adam248
      chewblacka
      kaptcha0
    ];
  };
}

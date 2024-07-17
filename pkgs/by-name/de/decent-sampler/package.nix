{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  buildFHSEnv,
  alsa-lib,
  freetype,
  nghttp2,
  libX11,
}:

let
  pname = "decent-sampler";
  version = "1.10.0";

  icon = fetchurl {
    url = "https://archive.org/download/ds-256/DS256.png";
    hash = "sha256-SV8zY5QJ6uRSrLuGTmT1zwGoIIXCV9GD2ZNiqK+i1Bc=";
  };

  decent-sampler = stdenv.mkDerivation {
    inherit pname version;

    src = fetchzip {
      # dropbox links: https://www.dropbox.com/sh/dwyry6xpy5uut07/AABBJ84bjTTSQWzXGG5TOQpfa\
      url = "https://archive.org/download/decent-sampler-linux-static-download-mirror/Decent_Sampler-${version}-Linux-Static-x86_64.tar.gz";
      hash = "sha256-KYCf/F2/ziuXDHim4FPZQBARiSywvQDJBzKbHua+3SM=";
    };

    nativeBuildInputs = [ copyDesktopItems ];

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

    installPhase = ''
      runHook preInstall

      install -Dm755 DecentSampler $out/bin/decent-sampler
      install -Dm755 DecentSampler.so -t $out/lib/vst
      install -d "$out/lib/vst3" && cp -r "DecentSampler.vst3" $out/lib/vst3
      install -Dm444 ${icon} $out/share/pixmaps/decent-sampler.png

      runHook postInstall
    '';
  };

in

buildFHSEnv {
  inherit (decent-sampler) pname version;

  targetPkgs = pkgs: [
    alsa-lib
    decent-sampler
    freetype
    nghttp2
    libX11
  ];

  runScript = "decent-sampler";

  extraInstallCommands = ''
    cp -r ${decent-sampler}/lib $out/lib
    cp -r ${decent-sampler}/share $out/share
  '';

  meta = with lib; {
    description = "An audio sample player";
    longDescription = ''
      Decent Sampler is an audio sample player.
      Allowing you to play sample libraries in the DecentSampler format
      (files with extensions: dspreset and dslibrary).
    '';
    mainProgram = "decent-sampler";
    homepage = "https://www.decentsamples.com/product/decent-sampler-plugin/";
    # It claims to be free but we currently cannot find any license
    # that it is released under.
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ adam248 ];
  };
}

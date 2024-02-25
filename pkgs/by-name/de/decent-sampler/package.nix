{ lib
, stdenv
, fetchzip
, buildFHSEnv
, alsa-lib
, freetype
, nghttp2
, libX11
, }:

let
  pname = "decent-sampler";
  version = "1.10.0";

  decent-sampler = stdenv.mkDerivation rec {
    inherit pname version;

    src = fetchzip {
      # dropbox link: https://www.dropbox.com/sh/dwyry6xpy5uut07/AABBJ84bjTTSQWzXGG5TOQpfa\
      url = "https://archive.org/download/decent-sampler-linux-static-download-mirror/Decent_Sampler-${version}-Linux-Static-x86_64.tar.gz";
      hash = "sha256-KYCf/F2/ziuXDHim4FPZQBARiSywvQDJBzKbHua+3SM=";
    };

    installPhase = ''
      runHook preInstall

      install -Dm755 DecentSampler $out/bin/decent-sampler
      install -Dm755 DecentSampler.so -t $out/lib/vst
      install -d "$out/lib/vst3" && cp -r "DecentSampler.vst3" $out/lib/vst3

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
    cp -r ${decent-sampler.outPath}/lib $out/lib
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

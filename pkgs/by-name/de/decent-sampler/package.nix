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
  version = "1.9.4";

  decent-sampler = stdenv.mkDerivation {
    inherit pname version;

    src = fetchzip {
      # dropbox link: https://www.dropbox.com/sh/dwyry6xpy5uut07/AABBJ84bjTTSQWzXGG5TOQpfa\

      url = "https://archive.org/download/decent-sampler-linux-static-download-mirror/Decent_Sampler-${version}-Linux-Static-x86_64.tar.gz";
      hash = "sha256-lTp/mukCwLNyeTcBT68eqa7aD0o11Bylbd93A5VCILU=";
    };

    installPhase = ''
      runHook preInstall

      install -Dm755 DecentSampler $out/bin/decent-sampler

      runHook postInstall
    '';
  };

in

buildFHSEnv {
  inherit pname version;

  targetPkgs = pkgs: [
    alsa-lib
    decent-sampler
    freetype
    nghttp2
    libX11
  ];

  runScript = "decent-sampler";

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

{ lib
, stdenv
, fetchzip
, buildFHSEnv
, alsa-lib
, freetype
, nghttp2
, xorg
, }:

let
  pname = "decent-sampler";
  version = "1.9.4";

  decent-sampler = stdenv.mkDerivation {
    inherit pname version;

    src = fetchzip {
      # dropbox link: https://www.dropbox.com/sh/dwyry6xpy5uut07/AABBJ84bjTTSQWzXGG5TOQpfa\

      url = "https://archive.org/download/decent-sampler-linux-static-download-mirror/Decent_Sampler-${version}-Linux-Static-x86_64.tar.gz";
      sha256 = "sha256-O/0R70tZOmSGgth6nzt4zPiJr1P8890uzk8PiQGnC6M=";
    };

    installPhase = ''
      mkdir -p $out/bin
      install -m755 "DecentSampler" "$out/bin/decent-sampler"
    '';

  };
in

buildFHSEnv {
  inherit pname version;

  targetPkgs = pkgs: [
    decent-sampler
    alsa-lib
    freetype
    nghttp2
    xorg.libX11
  ];

  runScript = "decent-sampler";

  meta = with lib; {
    description = "An audio sample player";
    longDescription = ''
        Decent Sampler is an audio sample player.
        Allowing you to play sample libraries in the DecentSampler format
        (files with extensions: dspreset and dslibrary).
        It claims to be free but we currently cannot find any license
        that it is released under.
    '';
    homepage = "https://www.decentsamples.com/product/decent-sampler-plugin/";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ adam248 ];
  };
}


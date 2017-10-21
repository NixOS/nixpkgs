{ stdenv, fetchurl
, raspberrypifw, pcre, boost, freetype, zlib
, hostPlatform
}:

let
  ffmpeg = stdenv.mkDerivation rec {
    name = "ffmpeg-1.1.3";
    
    src = fetchurl {
      url = "http://www.ffmpeg.org/releases/${name}.tar.bz2";
      sha256 = "03s1zsprz5p6gjgwwqcf7b6cvzwwid6l8k7bamx9i0f1iwkgdm0j";
    };
    
    configureFlags = [
      "--arch=arm"
      "--cpu=arm1176jzf-s"
      "--disable-muxers"
      "--enable-muxer=spdif"
      "--enable-muxer=adts"
      "--disable-encoders"
      "--enable-encoder=ac3"
      "--enable-encoder=aac"
      "--disable-decoder=mpeg_xvmc"
      "--disable-devices"
      "--disable-ffprobe"
      "--disable-ffplay"
      "--disable-ffserver"
      "--disable-ffmpeg"
      "--enable-shared"
      "--disable-doc"
      "--enable-postproc"
      "--enable-gpl"
      "--enable-protocol=http"
      "--enable-pthreads"
      "--disable-runtime-cpudetect"
      "--enable-pic"
      "--disable-armv5te"
      "--disable-neon"
      "--enable-armv6t2"
      "--enable-armv6"
      "--enable-hardcoded-tables"
      "--disable-runtime-cpudetect"
      "--disable-debug"
    ];

    enableParallelBuilding = true;
      
    crossAttrs = {
      configurePlatforms = [];
      configureFlags = configureFlags ++ [
        "--cross-prefix=${stdenv.cc.prefix}"
        "--enable-cross-compile"
        "--target_os=linux"
        "--arch=${hostPlatform.arch}"
        ];
    };

    meta = {
      homepage = http://www.ffmpeg.org/;
      description = "A complete, cross-platform solution to record, convert and stream audio and video";
    };
  };
in
stdenv.mkDerivation rec {
  name = "omxplayer-20130328-fbee325dc2";
  src = fetchurl {
    url = https://github.com/huceke/omxplayer/tarball/fbee325dc2;
    name = "${name}.tar.gz";
    sha256 = "0fkvv8il7ffqxki2gp8cxa5shh6sz9jsy5vv3f4025g4gss6afkg";
  };
  patchPhase = ''
    sed -i 1d Makefile
    export INCLUDES="-I${raspberrypifw}/include/interface/vcos/pthreads -I${raspberrypifw}/include/interface/vmcs_host/linux/"
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp omxplayer.bin $out/bin
  '';
  buildInputs = [ raspberrypifw ffmpeg pcre boost freetype zlib ];

  meta = {
    homepage = https://github.com/huceke/omxplayer;
    description = "Commandline OMX player for the Raspberry Pi";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}

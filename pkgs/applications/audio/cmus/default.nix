{ config, lib, stdenv, fetchFromGitHub, runCommand, ncurses, pkg-config
, libiconv, CoreAudio, AudioUnit

, alsaSupport ? stdenv.isLinux, alsa-lib
# simple fallback for everyone else
, aoSupport ? !stdenv.isLinux, libao
, jackSupport ? false, libjack
, samplerateSupport ? jackSupport, libsamplerate
, ossSupport ? false, alsa-oss
, pulseaudioSupport ? config.pulseaudio or false, libpulseaudio
, mprisSupport ? stdenv.isLinux, systemd

# TODO: add these
#, artsSupport
#, roarSupport
#, sndioSupport
#, sunSupport
#, waveoutSupport

, cddbSupport ? true, libcddb
, cdioSupport ? true, libcdio, libcdio-paranoia
, cueSupport ? true, libcue
, discidSupport ? (!stdenv.isDarwin), libdiscid
, ffmpegSupport ? true, ffmpeg
, flacSupport ? true, flac
, madSupport ? true, libmad
, mikmodSupport ? true, libmikmod
, modplugSupport ? true, libmodplug
, mpcSupport ? true, libmpcdec
, tremorSupport ? false, tremor
, vorbisSupport ? true, libvorbis
, wavpackSupport ? true, wavpack
, opusSupport ? true, opusfile

, aacSupport ? false, faad2 # already handled by ffmpeg
, mp4Support ? false, mp4v2 # ffmpeg does support mp4 better

# not in nixpkgs
#, vtxSupport ? true, libayemu ? null
}:

with lib;

assert samplerateSupport -> jackSupport;

# vorbis and tremor are mutually exclusive
assert vorbisSupport -> !tremorSupport;
assert tremorSupport -> !vorbisSupport;

let

  mkFlag = b: f: dep: if b
    then { flags = [ f ]; deps = [ dep ]; }
    else { flags = []; deps = []; };

  opts = [
    # Audio output
    (mkFlag alsaSupport       "CONFIG_ALSA=y"       alsa-lib)
    (mkFlag aoSupport         "CONFIG_AO=y"         libao)
    (mkFlag jackSupport       "CONFIG_JACK=y"       libjack)
    (mkFlag samplerateSupport "CONFIG_SAMPLERATE=y" libsamplerate)
    (mkFlag ossSupport        "CONFIG_OSS=y"        alsa-oss)
    (mkFlag pulseaudioSupport "CONFIG_PULSE=y"      libpulseaudio)
    (mkFlag mprisSupport      "CONFIG_MPRIS=y"      systemd)

    #(mkFlag artsSupport      "CONFIG_ARTS=y")
    #(mkFlag roarSupport      "CONFIG_ROAR=y")
    #(mkFlag sndioSupport     "CONFIG_SNDIO=y")
    #(mkFlag sunSupport       "CONFIG_SUN=y")
    #(mkFlag waveoutSupport   "CONFIG_WAVEOUT=y")

    # Input file formats
    (mkFlag cddbSupport    "CONFIG_CDDB=y"    libcddb)
    (mkFlag cdioSupport    "CONFIG_CDIO=y"    [ libcdio libcdio-paranoia ])
    (mkFlag cueSupport     "CONFIG_CUE=y"     libcue)
    (mkFlag discidSupport  "CONFIG_DISCID=y"  libdiscid)
    (mkFlag ffmpegSupport  "CONFIG_FFMPEG=y"  ffmpeg)
    (mkFlag flacSupport    "CONFIG_FLAC=y"    flac)
    (mkFlag madSupport     "CONFIG_MAD=y"     libmad)
    (mkFlag mikmodSupport  "CONFIG_MIKMOD=y"  libmikmod)
    (mkFlag modplugSupport "CONFIG_MODPLUG=y" libmodplug)
    (mkFlag mpcSupport     "CONFIG_MPC=y"     libmpcdec)
    (mkFlag tremorSupport  "CONFIG_TREMOR=y"  tremor)
    (mkFlag vorbisSupport  "CONFIG_VORBIS=y"  libvorbis)
    (mkFlag wavpackSupport "CONFIG_WAVPACK=y" wavpack)
    (mkFlag opusSupport   "CONFIG_OPUS=y"    opusfile)

    (mkFlag mp4Support    "CONFIG_MP4=y"     mp4v2)
    (mkFlag aacSupport    "CONFIG_AAC=y"     faad2)

    #(mkFlag vtxSupport    "CONFIG_VTX=y"     libayemu)
  ];

  clangGCC = runCommand "clang-gcc" {} ''
    #! ${stdenv.shell}
    mkdir -p $out/bin
    ln -s ${stdenv.cc}/bin/clang $out/bin/gcc
    ln -s ${stdenv.cc}/bin/clang++ $out/bin/g++
  '';

in

stdenv.mkDerivation rec {
  pname = "cmus";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner  = "cmus";
    repo   = "cmus";
    rev    = "v${version}";
    sha256 = "sha256-HEiEnEWf/MzhPO19VKTLYzhylpEvyzy1Jxs6EW2NU34=";
  };

  patches = [ ./option-debugging.patch ];

  configurePhase = "./configure " + concatStringsSep " " ([
    "prefix=$out"
    "CONFIG_WAV=y"
  ] ++ concatMap (a: a.flags) opts);

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ]
    ++ lib.optional stdenv.cc.isClang clangGCC
    ++ lib.optionals stdenv.isDarwin [ libiconv CoreAudio AudioUnit ]
    ++ flatten (concatMap (a: a.deps) opts);

  makeFlags = [ "LD=$(CC)" ];

  meta = with lib; {
    description = "Small, fast and powerful console music player for Linux and *BSD";
    homepage = "https://cmus.github.io/";
    license = licenses.gpl2;
    maintainers = [ maintainers.oxij ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

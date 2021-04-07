{ config, lib, stdenv, fetchFromGitHub, runCommand, ncurses, pkg-config
, libiconv, CoreAudio, AudioUnit

, alsaSupport ? stdenv.isLinux, alsaLib ? null
# simple fallback for everyone else
, aoSupport ? !stdenv.isLinux, libao ? null
, jackSupport ? false, libjack ? null
, samplerateSupport ? jackSupport, libsamplerate ? null
, ossSupport ? false, alsaOss ? null
, pulseaudioSupport ? config.pulseaudio or false, libpulseaudio ? null
, mprisSupport ? stdenv.isLinux, systemd ? null

# TODO: add these
#, artsSupport
#, roarSupport
#, sndioSupport
#, sunSupport
#, waveoutSupport

, cddbSupport ? true, libcddb ? null
, cdioSupport ? true, libcdio ? null, libcdio-paranoia ? null
, cueSupport ? true, libcue ? null
, discidSupport ? (!stdenv.isDarwin), libdiscid ? null
, ffmpegSupport ? true, ffmpeg ? null
, flacSupport ? true, flac ? null
, madSupport ? true, libmad ? null
, mikmodSupport ? true, libmikmod ? null
, modplugSupport ? true, libmodplug ? null
, mpcSupport ? true, libmpcdec ? null
, tremorSupport ? false, tremor ? null
, vorbisSupport ? true, libvorbis ? null
, wavpackSupport ? true, wavpack ? null
, opusSupport ? true, opusfile ? null

, aacSupport ? false, faad2 ? null # already handled by ffmpeg
, mp4Support ? false, mp4v2 ? null # ffmpeg does support mp4 better

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
    (mkFlag alsaSupport       "CONFIG_ALSA=y"       alsaLib)
    (mkFlag aoSupport         "CONFIG_AO=y"         libao)
    (mkFlag jackSupport       "CONFIG_JACK=y"       libjack)
    (mkFlag samplerateSupport "CONFIG_SAMPLERATE=y" libsamplerate)
    (mkFlag ossSupport        "CONFIG_OSS=y"        alsaOss)
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

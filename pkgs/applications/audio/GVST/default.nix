{ stdenv
, lib
, libX11
, libXt
, cairo
, unzip
, fetchurl
, autoPatchelfHook
}:

let
  pname = "GVST";
  version = "0.0.1-beta";
  owner = "ezemtsov";
  vst_path = "/run/current-system/sw/lib/vst";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    curlOpts = [ "-O" "-H" "Referer: https://www.gvst.co.uk/portpage.htm"];
    url = "https://www.gvst.co.uk/dl/AllGVSTLinux64Beta.zip";
    sha256 = "0nv64pyyjz3inxsd0grcp5sjckrx6p84zyl08jjrmzwyha4ic420";
  };

  nativeBuildInputs = [ unzip autoPatchelfHook ];

  buildInputs = [ libX11 libXt cairo ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    find ./*.so -type f -exec install -m 755 -D "{}" $out/lib/vst/{} \;
  '';

  meta = with stdenv.lib; {
    homepage = https://www.gvst.co.uk;
    description = "Collection of open-source audio plugins";

    longDescription = ''
      Contains the following plugins:

        Effects
        - GBand - Band-pass filter.
        - GChorus - Chorus effect.
        - GClip - Wave-shaping signal clipper.
        - GComp - Compressor.
        - GComp2 - Compressor.
        - GDelay - Delay effect.
        - GDuckDly - Ducking delay effect.
        - GFader - Signal gain (-100 to 0 dB).
        - GGain - Signal gain (-12 to 12 dB).
        - GGate - Gate.
        - GGrain - Granular resynthesis.
        - GHi - High-pass filter.
        - GLow - Low-pass filter.
        - GLFO - Triple LFO effect.
        - GMax - Limiter.
        - GMonoBass - Bass stereo imaging effect.
        - GMulti - Multi-band compressor and stereo enhancer.
        - GNormal - Noise generator for avoiding denormal problems.
        - GRevDly - Reverse delay effect.
        - GSnap - Pitch-correction.
        - GTune - Chromatic tuner.

        Instruments
        - GSinth - Mono synth using three continuous portamento sine generators.
        - GSinth2 - Extends GSinth by adding triangle, square and saw-tooth wave.
    '';
    platforms = platforms.linux;
    maintainers = [ maintainers.ezemtsov ];
    license = licenses.unfree;
  };
}

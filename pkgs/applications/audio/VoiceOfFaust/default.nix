
{ stdenv, pkgs, callPackage, fetchFromGitHub, faust2jack, helmholtz, mrpeach, puredata-with-plugins }:
stdenv.mkDerivation rec {
  name = "VoiceOfFaust-${version}";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "VoiceOfFaust";
    rev = "v${version}";
    sha256 = "14jjs7cnhg20pzijgblr7caspcpx8p8lpkbvjzc656s9lqn6m9sn";
  };

  plugins = [ helmholtz mrpeach ];

  pitchTracker = puredata-with-plugins plugins;

  buildInputs = [ faust2jack ];

  runtimeInputs = [ pitchTracker ];

  patchPhase = ''
    sed -i "s@pd -nodac@${pitchTracker}/bin/pd -nodac@g" launchers/synthWrapper
    sed -i "s@../PureData/OscSendVoc.pd@$out/PureData/OscSendVoc.pd@g" launchers/synthWrapper
  '';

  buildPhase = ''
    faust2jack -osc classicVocoder.dsp
    faust2jack -osc CZringmod.dsp
    faust2jack -osc FMsinger.dsp
    faust2jack -osc FOFvocoder.dsp
    faust2jack -osc Karplus-StrongSinger.dsp
    faust2jack -osc -sch -t 99999 Karplus-StrongSingerMaxi.dsp
    faust2jack -osc PAFvocoder.dsp
    faust2jack -osc -sch -t 99999 stringSinger.dsp
    faust2jack -osc subSinger.dsp
    # doesn't compile on most systems, too big:
    #faust2jack -osc -sch -t 99999 VocSynthFull.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp launchers/* $out/bin/
    cp classicVocoder $out/bin/
    cp CZringmod $out/bin/
    cp FMsinger $out/bin/
    cp FOFvocoder $out/bin/
    cp Karplus-StrongSinger $out/bin/
    cp Karplus-StrongSingerMaxi $out/bin/
    cp PAFvocoder $out/bin/
    cp stringSinger $out/bin/
    cp subSinger $out/bin/
    #cp VocSynthFull $out/bin/
    mkdir $out/PureData/
    cp PureData/OscSendVoc.pd $out/PureData/OscSendVoc.pd
  '';

  meta = {
    description = "Turn your voice into a synthesizer";
    homepage = https://github.com/magnetophon/VoiceOfFaust;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}


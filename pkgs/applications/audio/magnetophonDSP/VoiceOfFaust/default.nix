{
  lib,
  stdenv,
  fetchFromGitHub,
  faust2jack,
  faust2lv2,
  helmholtz,
  mrpeach,
  puredata-with-plugins,
  jack-example-tools,
}:
stdenv.mkDerivation rec {
  pname = "VoiceOfFaust";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "VoiceOfFaust";
    tag = "V${version}";
    sha256 = "sha256-wsc4yzytK2hPVBQwMhdhjnH1pDtpkNCFJnItyzszEs0=";
  };

  plugins = [
    helmholtz
    mrpeach
  ];

  pitchTracker = puredata-with-plugins plugins;

  nativeBuildInputs = [
    faust2jack
    faust2lv2
  ];

  enableParallelBuilding = true;

  dontWrapQtApps = true;

  makeFlags = [
    "PREFIX=$(out)"
  ];

  patchPhase = ''
    sed -i "s@jack_connect@${jack-example-tools}/bin/jack_connect@g" launchers/synthWrapper
    sed -i "s@pd -nodac@${pitchTracker}/bin/pd -nodac@g" launchers/pitchTracker
    sed -i "s@../PureData/OscSendVoc.pd@$out/bin/PureData/OscSendVoc.pd@g" launchers/pitchTracker
    sed -i "s@pd -nodac@${pitchTracker}/bin/pd -nodac@g" launchers/pitchTrackerGUI
    sed -i "s@../PureData/OscSendVoc.pd@$out/bin/PureData/OscSendVoc.pd@g" launchers/pitchTrackerGUI
  '';

  meta = {
    description = "Turn your voice into a synthesizer";
    homepage = "https://github.com/magnetophon/VoiceOfFaust";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}

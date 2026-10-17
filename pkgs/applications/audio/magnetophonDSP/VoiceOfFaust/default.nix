{
  lib,
  stdenv,
  fetchFromGitHub,
  faust2jack,
  faust2lv2,
  helmholtz,
  puredata-with-plugins,
  jack-example-tools,
}:
let
  plugins = [
    helmholtz
  ];
  pitchTracker = puredata-with-plugins plugins;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "VoiceOfFaust";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "VoiceOfFaust";
    tag = "V${finalAttrs.version}";
    sha256 = "sha256-wsc4yzytK2hPVBQwMhdhjnH1pDtpkNCFJnItyzszEs0=";
  };

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
})

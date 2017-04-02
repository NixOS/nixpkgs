{ stdenv, pkgs, callPackage, fetchFromGitHub, faust2jack, faust2lv2, helmholtz, mrpeach, puredata-with-plugins }:
stdenv.mkDerivation rec {
  name = "VoiceOfFaust-${version}";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "VoiceOfFaust";
    rev = "V${version}";
    sha256 = "0la9b806qwrlsxgbir7n1db8v3w24wmd6k43p6qpr1fjjpkhrrgw";
  };

  plugins = [ helmholtz mrpeach ];

  pitchTracker = puredata-with-plugins plugins;

  buildInputs = [ faust2jack faust2lv2 ];

  runtimeInputs = [ pitchTracker ];

  patchPhase = ''
    sed -i "s@pd -nodac@${pitchTracker}/bin/pd -nodac@g" launchers/synthWrapper
    sed -i "s@../PureData/OscSendVoc.pd@$out/PureData/OscSendVoc.pd@g" launchers/pitchTracker
  '';

  buildPhase = ''
    sh install.sh
    # so it doesn;t end up in /bin/ :
    rm -f install.sh
  '';

  installPhase = ''
    mkdir -p $out/bin

    for file in ./*; do
      if test -x "$file" && test -f "$file"; then
        cp "$file" "$out/bin"
      fi
    done

    cp launchers/* $out/bin/
    mkdir $out/PureData/
    # cp PureData/OscSendVoc.pd $out/PureData/OscSendVoc.pd
    cp PureData/* $out/PureData/

    mkdir -p $out/lib/lv2
    cp -r *.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "Turn your voice into a synthesizer";
    homepage = https://github.com/magnetophon/VoiceOfFaust;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}

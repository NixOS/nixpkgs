{
  lib,
  symlinkJoin,
  makeWrapper,
  piper-tts,
  piper-tts-zh,
  piperTtsVoices,
  g2pwModel,
}:

voiceSelector:
let
  isVoice = v: lib.isAttrs v && v ? model && v ? modelConfig;
  voices = lib.filterAttrs (_: isVoice) piperTtsVoices.voices;
  selected = voiceSelector voices;

  needsZh = lib.any (v: v.language.family == "zh") selected;
  piper-tts' = if needsZh then piper-tts-zh else piper-tts;
in
symlinkJoin {
  name = "piper-tts-with-voices";
  paths = [ piper-tts' ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    mkdir -p $out/share/piper-voices
  ''
  + lib.concatMapStringsSep "\n" (v: ''
    ln -s ${v.model} $out/share/piper-voices/${v.key}.onnx
    ln -s ${v.modelConfig} $out/share/piper-voices/${v.key}.onnx.json
  '') selected
  + lib.optionalString needsZh ''
    mkdir -p $out/share/piper-extra-models-dir/g2pW
    ln -s ${g2pwModel}/* $out/share/piper-extra-models-dir/g2pW/
  ''
  + ''
    wrapProgram $out/bin/piper \
      --add-flags "--data-dir $out/share/piper-voices" \
      --add-flags "--extra-models-dir $out/share/piper-extra-models-dir"
  '';
}

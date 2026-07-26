{
  lib,
  fetchurl,
  linkFarm,
  stdenv,
}:

let
  rev = "0d907f158acc877ddeebcbf827659ee13bea8bcd";

  voicesJsonUpstream = fetchurl {
    name = "piper-voices-voices.json-upstream";
    url = "https://huggingface.co/rhasspy/piper-voices/resolve/${rev}/voices.json";
    sha256 = builtins.hashFile "sha256" ./voices.json;
  };

  voices = builtins.fromJSON (builtins.readFile ./voices.json);
  fileHashes = builtins.fromJSON (builtins.readFile ./file-hashes.json);

  voiceSet = lib.mapAttrs (
    key: voice:
    let
      fetched = lib.mapAttrs (
        path: _:
        fetchurl {
          url = "https://huggingface.co/rhasspy/piper-voices/resolve/${rev}/${path}";
          hash = (fileHashes.${path} or { sha256 = lib.fakeHash; }).sha256;
        }
      ) voice.files;
      onnxPath = lib.findFirst (lib.hasSuffix ".onnx") null (lib.attrNames voice.files);
      model = fetched.${onnxPath};
      modelConfig = fetched."${onnxPath}.json";
      modelCardPath = lib.findFirst (lib.hasSuffix "MODEL_CARD") null (lib.attrNames voice.files);
      modelCard = fetched.${modelCardPath};
      voiceDir = dirOf modelCardPath;
    in
    linkFarm key {
      "${key}.onnx" = model;
      "${key}.onnx.json" = modelConfig;
      "MODEL_CARD" = modelCard;
    }
    // {
      inherit
        key
        model
        modelConfig
        modelCard
        ;
      inherit (voice)
        name
        language
        quality
        num_speakers
        ;
      meta = {
        homepage = "https://huggingface.co/rhasspy/piper-voices/tree/${rev}/${voiceDir}";
        maintainers = with lib.maintainers; [ WiredMic ];
      };
    }
  ) voices;
in
stdenv.mkDerivation {
  pname = "piper-tts-voices";
  version = rev;
  src = voicesJsonUpstream;

  __structuredAttrs = true;
  strictDeps = true;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    runHook postInstall
  '';

  passthru = {
    voices = voiceSet;
    tests.voices-json-up-to-date = voicesJsonUpstream;
    updateScript = [ ./update-piper-voices.sh ];
  };

  meta = {
    description = "Voice models for piper-tts";
    homepage = "https://huggingface.co/rhasspy/piper-voices";
    license = lib.licenses.mit;
  };
}
// voiceSet

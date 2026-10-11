{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  whisperRev = "3d3d5dee26484f91867d81cb899cfcf72b96be6c";
  whisperBase = "https://huggingface.co/Systran/faster-whisper-base.en/resolve/${whisperRev}";

  whisperFile =
    name: hash:
    fetchurl {
      url = "${whisperBase}/${name}";
      inherit hash;
    };

  whisperFiles = {
    "config.json" = whisperFile "config.json" "sha256-87w4Ien8dqJ7rlOOEa5bZ33N01K0YAQpznlR05hWmus=";
    "model.bin" = whisperFile "model.bin" "sha256-KhZpJVOaFgBfFP8yg1n5ua253E+2Mbs7InUmhi6T4u8=";
    "tokenizer.json" =
      whisperFile "tokenizer.json" "sha256-kpxSUkCUNtzhs4p10au8teEy0XDY4yTk4E7ZFfotIt8=";
    "vocabulary.txt" =
      whisperFile "vocabulary.txt" "sha256-/3dYh0bTolldMqtbaf/XuVziRBrFdTPLZvw+tXWhFc8=";
  };

  piperBase = "https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/amy/medium";

  piperOnnx = fetchurl {
    url = "${piperBase}/en_US-amy-medium.onnx";
    hash = "sha256-s6bke1e4x/vmoM4lGBYaUPWanN2KUINcAssCvdYgbBg=";
  };

  piperJson = fetchurl {
    url = "${piperBase}/en_US-amy-medium.onnx.json";
    hash = "sha256-laI+tNQpCdON9zu5rH9F9Zfb/N4tG/lSb96vVGaXfXc=";
  };

in
stdenvNoCC.mkDerivation {
  pname = "easyspeak-lang-en";
  version = "1.0.0";

  __structuredAttrs = true;

  strictDeps = true;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/models/whisper/base.en" "$out/models/piper"

    ${lib.concatStringsSep "\n    " (
      lib.mapAttrsToList (
        name: file: "ln -s ${file} \"$out/models/whisper/base.en/${name}\""
      ) whisperFiles
    )}

    ln -s ${piperOnnx} "$out/models/piper/en_US-amy-medium.onnx"
    ln -s ${piperJson} "$out/models/piper/en_US-amy-medium.onnx.json"

    runHook postInstall
  '';

  passthru.models = {
    whisper = "models/whisper/base.en";
    piper = "models/piper/en_US-amy-medium.onnx";
  };

  meta = {
    description = "English speech models for EasySpeak (Whisper base.en + Piper en_US-amy-medium)";
    homepage = "https://easyspeak.dev";
    license = [
      lib.licenses.mit
      lib.licenses.cc-by-sa-40
    ];
    maintainers = [ lib.maintainers.ahoneybun ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}

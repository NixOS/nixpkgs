{ lib
, fetchFromGitHub
, python3
, python3Packages
, onnxruntime
}:

python3Packages.buildPythonApplication rec {
  pname = "mimic3";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "MycroftAI";
    repo = "mimic3";
    rev = "refs/tags/release/v${version}";
    sha256 = "sha256-/uL0YGblDUWTGeIFK0ILadJ6tE0u3sj/ovfoWJ4UkRk=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'epitran==1.17' 'epitran' \
      --replace 'swagger-ui-py>=21,<22' 'swagger-ui-py'

    substituteInPlace mimic3_tts/tts.py --replace \
      'providers = None' \
      'providers = ["DnnlExecutionProvider", "CPUExecutionProvider"]'
  '';

  # TODO mimic3 can't find libonnxruntime_providers_shared.so
  buildInputs = [ onnxruntime ];

  propagatedBuildInputs = with python3Packages; [
    dataclasses-json
    epitran
    espeak-phonemizer
    gruut
    numpy
    python3Packages.onnxruntime
    phonemes2ids
    quart
    quart-cors
    requests
    swagger-ui-py
    tqdm
    xdgenvpy
  ];

  meta = with lib; {
    changelog = "https://github.com/MycroftAI/mimic3/releases/tag/release%2Fv${version}";
    description = "A fast local neural text to speech engine for Mycroft";
    homepage = "https://mycroft.ai/mimic-3/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ felschr ];
  };
}

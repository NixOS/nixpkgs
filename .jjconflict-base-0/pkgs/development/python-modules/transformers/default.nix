{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  filelock,
  huggingface-hub,
  numpy,
  protobuf,
  packaging,
  pyyaml,
  regex,
  requests,
  tokenizers,
  safetensors,
  tqdm,

  # optional-dependencies
  diffusers,
  scikit-learn,
  tensorflow,
  onnxconverter-common,
  opencv4,
  tf2onnx,
  torch,
  accelerate,
  faiss,
  datasets,
  jax,
  jaxlib,
  flax,
  optax,
  ftfy,
  onnxruntime,
  onnxruntime-tools,
  cookiecutter,
  sagemaker,
  fairscale,
  optuna,
  ray,
  pydantic,
  uvicorn,
  fastapi,
  starlette,
  librosa,
  phonemizer,
  torchaudio,
  pillow,
  timm,
  torchvision,
  av,
  sentencepiece,
}:

buildPythonPackage rec {
  pname = "transformers";
  version = "4.47.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "transformers";
    tag = "v${version}";
    hash = "sha256-TQQ+w+EH/KWLE7iaaAHGxfE74hCiLXcqlIr1TIBFGvo=";
  };

  # torch.distributed is not available on darwin
  # Fix submitted upstream in https://github.com/huggingface/transformers/pull/35133
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/transformers/pytorch_utils.py \
      --replace-fail \
        'if is_torch_greater_or_equal("2.5"):' \
        'if False:'
  '';

  build-system = [ setuptools ];

  dependencies = [
    filelock
    huggingface-hub
    numpy
    packaging
    pyyaml
    regex
    requests
    tokenizers
    safetensors
    tqdm
  ];

  optional-dependencies =
    let
      audio = [
        librosa
        # pyctcdecode
        phonemizer
        # kenlm
      ];
      vision = [ pillow ];
    in
    {
      agents = [
        diffusers
        accelerate
        datasets
        torch
        sentencepiece
        opencv4
        pillow
      ];
      ja = [
        # fugashi
        # ipadic
        # rhoknp
        # sudachidict_core
        # sudachipy
        # unidic
        # unidic_lite
      ];
      sklearn = [ scikit-learn ];
      tf = [
        tensorflow
        onnxconverter-common
        tf2onnx
        # tensorflow-text
        # keras-nlp
      ];
      torch = [
        torch
        accelerate
      ];
      retrieval = [
        faiss
        datasets
      ];
      flax = [
        jax
        jaxlib
        flax
        optax
      ];
      tokenizers = [ tokenizers ];
      ftfy = [ ftfy ];
      onnxruntime = [
        onnxruntime
        onnxruntime-tools
      ];
      onnx = [
        onnxconverter-common
        tf2onnx
        onnxruntime
        onnxruntime-tools
      ];
      modelcreation = [ cookiecutter ];
      sagemaker = [ sagemaker ];
      deepspeed = [
        # deepspeed
        accelerate
      ];
      fairscale = [ fairscale ];
      optuna = [ optuna ];
      ray = [ ray ] ++ ray.optional-dependencies.tune;
      # sigopt = [ sigopt ];
      # integrations = ray ++ optuna ++ sigopt;
      serving = [
        pydantic
        uvicorn
        fastapi
        starlette
      ];
      audio = audio;
      speech = [ torchaudio ] ++ audio;
      torch-speech = [ torchaudio ] ++ audio;
      tf-speech = audio;
      flax-speech = audio;
      timm = [ timm ];
      torch-vision = [ torchvision ] ++ vision;
      # natten = [ natten ];
      # codecarbon = [ codecarbon ];
      video = [
        av
      ];
      sentencepiece = [
        sentencepiece
        protobuf
      ];
    };

  # Many tests require internet access.
  doCheck = false;

  pythonImportsCheck = [ "transformers" ];

  meta = {
    homepage = "https://github.com/huggingface/transformers";
    description = "Natural Language Processing for TensorFlow 2.0 and PyTorch";
    mainProgram = "transformers-cli";
    changelog = "https://github.com/huggingface/transformers/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pashashocky
      happysalada
    ];
  };
}

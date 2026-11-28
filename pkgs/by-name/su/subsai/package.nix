{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
  nix-update-script,
}:

python3Packages.buildPythonApplication {
  pname = "subsai";
  version = "1.6.2-unstable-2026-04-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "absadiki";
    repo = "subsai";
    rev = "5ed78a85d2b868a907c811404f7cd9179db39968";
    hash = "sha256-DN6pP0eShSmotHi7DcJGOiQGUjsFCiSYEtpzA14nUos=";
  };

  postPatch = ''
    # Silence noisy import errors for unpackaged optional backends (pywhispercpp, stable-ts)
    substituteInPlace src/subsai/configs.py \
      --replace-fail "    print(e)" "    pass"
  '';

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "dl_translate"
    "ffsubsync"
    "numpy"
    "openai"
    "openai-whisper"
    "pysubs2"
    "torch"
    "torchaudio"
    "transformers"
    "whisper-timestamped"
    "whisperx"
  ];

  pythonRemoveDeps = [
    # Unpackaged optional backends
    "pywhispercpp"
    "stable-ts"
    # Web-UI dependencies (not needed for CLI usage)
    "pandas"
    "streamlit"
    "streamlit-aggrid"
    "streamlit_player"
  ];

  dependencies =
    with python3Packages;
    [
      dl-translate
      faster-whisper
      ffmpeg-python
      ffsubsync
      joblib
      numpy
      openai
      openai-whisper
      pydub
      pysubs2
      torch
      torchaudio
      tqdm
      transformers
      whisper-timestamped
      whisperx
    ]
    ++ python3Packages.whisper-timestamped.optional-dependencies.vad-silero;

  postInstall = ''
    rm $out/bin/subsai-webui
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  nativeCheckInputs = [
    ffmpeg
    python3Packages.pytestCheckHook
  ];

  # Tests load fixtures via relative paths (`../assets/...`) from `tests/`
  preCheck = ''
    pushd tests
  '';

  postCheck = ''
    popd
  '';

  disabledTests = [
    # Require network access to download models
    "test_create_model"
    "test_transcribe"
    "test_translate"
  ];

  pythonImportsCheck = [ "subsai" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Subtitles generation tool powered by OpenAI's Whisper and its variants";
    homepage = "https://github.com/absadiki/subsai";
    license = lib.licenses.gpl3Plus;
    mainProgram = "subsai";
    maintainers = with lib.maintainers; [ seirl ];
  };
}

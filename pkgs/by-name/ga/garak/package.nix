{
  lib,
  python3,
  fetchFromGitHub,
  fetchurl,
  fetchpatch2,
  writeText,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "garak";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "garak";
    rev = "v${version}";
    hash = "sha256-ePJ0Yd/QK/q/nKrVZfmczt+svA/kZWqSE9g2GtMQFYU=";
  };

  patches = [
    # allows us to use numpy v2
    # remove next release
    (fetchpatch2 {
      name = "replace-deprecated-numpy-func-infty-with-inf.patch";
      url = "https://github.com/NVIDIA/garak/pull/1283/commits/2d23788449c3ab3d264f1965630baeb4902c882b.patch?full_index=1";
      hash = "sha256-c1S0fOirX3rd/9h8TO9GDzukORfro0JGlUi7UWPBioM=";
    })

    # test_proves_topic.py tries to use wn before the other parts of garak
    # change where wn looks for files
    # https://github.com/NVIDIA/garak/pull/1316/
    ./tests-fix-test_probes_topic.patch

    # major bump
    ./use-cohere-5.patch
  ];

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  pythonRelaxDeps = [
    "cmd2"
    "deepl"
    "mistralai"
    "nvidia-riva-client"
    "numpy" # major bump
    "wn"
  ];

  dependencies = with python3.pkgs; [
    accelerate
    avidtools
    backoff
    base2048
    cmd2
    cohere
    colorama
    datasets
    deepl
    ecoji
    fschat
    ftfy
    google-api-python-client
    google-cloud-translate
    grpcio-tools
    huggingface-hub
    jinja2
    jsonpath-ng
    langchain
    langdetect
    litellm
    lorem
    markdown
    mistralai
    nemollm
    nltk
    numpy
    nvidia-riva-client
    ollama
    openai
    pillow
    python-magic
    rapidfuzz
    replicate
    sentencepiece
    stdlibs
    tiktoken
    torch
    tqdm
    transformers
    wn
    xdg-base-dirs
    zalgolib
  ];

  optional-dependencies = with python3.pkgs; {
    audio = [
      librosa
      soundfile
    ];

    calibration = [
      scipy
    ];
  };

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ (with python3.pkgs; [
    pytestCheckHook

    langcodes
    pytest-mock
    pytest-httpserver
    requests-futures
    requests-mock
    respx
  ])
  ++ optional-dependencies.audio;

  pythonImportsCheck = [ "garak" ];

  # tests use localhost
  __darwinAllowLocalNetworking = true;

  passthru.test-data = {
    nltk = python3.pkgs.nltk.dataDir (d: [
      d.stopwords
      d.punkt
      d.wordnet
    ]);
    lexicon = {
      name = "oewn:2023";
      data = fetchurl {
        url = "https://en-word.net/static/english-wordnet-2023.xml.gz";
        hash = "sha256-T7+f+cYq/4djjiHJmNbltJJ6nz7y6YggOv7ZatuFxeU=";
      };
    };
    # Wrap around `wn` python lib to load pre-fetched test lexicon.
    # Can't just unpack to a dir since `wn` prepares an sqlite3 db.
    # Also can't unpack to the default `data_directory` since garak changes that
    # at runtime.
    # https://github.com/NVIDIA/garak/blob/8fd22ee19b47613b9c2b728c35739276cd46ac6a/garak/probes/topic.py#L96
    loadLexiconScript = writeText "load-lexicon-for-garak.py" ''
      import sys
      from pathlib import Path
      from garak import _config
      import wn

      if len(sys.argv) < 2:
          print("Error: No input provided.")
          sys.exit(1)

      lexicon_file = sys.argv[1]
      if not isinstance(lexicon_file, str):
          print("Error: Input is not a string.")
          sys.exit(1)

      # garak overrides the wn data_directory so use the same dir
      wn.config.data_directory = _config.transient.cache_dir / "data" / "wn"
      Path(wn.config.data_directory).mkdir(parents=True, exist_ok=True)
      print("Loading lexicon", lexicon_file, "to", wn.config.data_directory)
      wn.add(lexicon_file)
    '';
  };

  preCheck =
    # garak overrides nltk loading in garak/resources/api/nltk.py
    # and doesn't respect NLTK_DATA env var
    ''
      mkdir -p "$HOME/.cache/data/" "$HOME/.cache/huggingface/hub" "$HOME/.cache/garak/data"
      ln -s ${passthru.test-data.nltk} "$HOME/.cache/data/nltk_data"
    ''
    +
    # prepare lexicon data via `wn` for tests/probes/test_probes_topic.py
    ''
      echo "Preparing ${passthru.test-data.lexicon.name} lexicon for use in testing"
      # check TEST_LEXICON matches the one we're using
      grep -q 'TEST_LEXICON = "${passthru.test-data.lexicon.name}"' tests/probes/test_probes_topic.py \
        || (echo "TEST_LEXICON has been updated, fix in garak package definition" && exit 1)
      python ${passthru.test-data.loadLexiconScript} ${passthru.test-data.lexicon.data}
      substituteInPlace tests/probes/test_probes_topic.py \
        --replace-fail "wn.download(TEST_LEXICON)" ""
    '';

  disabledTests = [
    # needs models from huggingface
    "test_atkgen_one_pass"
    "test_atkgen_probe"
    "test_atkgen_probe_translation"
    "test_buff_load_and_transform"
    "test_buff_results"
    "test_dont_start_no_reverse_translation"
    "test_dont_start_yes_reverse_translation"
    "test_hf_detector_detection"
    "test_hf_files_hf_repo"
    "test_instantiate_detectors"
    "test_local_translate_single_language"
    "test_model"
    "test_model_chat"
    "test_must_contradict_NLI_detection"
    "test_pipeline"
    "test_run_all_active_probes"
    "test_startswith_detect"
    "test_Tag_attempt_descrs_translation"
    "test_tox_safe"
    "test_tox_unsafe"
    "test_pipeline_chat"

    # runs cli, wants to fetch garak-llm/toxic-comment-model from huggingface
    # tries to access the 8th line of the jsonl report.
    # IndexError: list index out of range
    "test_attempt_sticky_params"

    # needs images from github
    "test_multi_modal_probe_translation"

    # needs audio from huggingface, images from github
    "test_instantiate_probes"

    # outputs len = 10, generations probe calls = 1
    "test_leakreplay_output_count"

    # AttributeError: 'WordnetControversial' object has no attribute 'prompts'
    "test_probe_prompt_translation"

    # generally needs models from huggingface
    # AssertionError: detector should return as many results as in all_outputs (maybe excluding Nones)
    # assert 0 in (3, 4)
    # +  where 0 = len([])
    # +    where [] = list([])
    "test_detector_detect"

    # needs datasets from huggingface for each language
    # e.g. garak-llm/npm-20240828, garak-llm/crates-20240903, etc
    # AssertionError: Misrecognition in core, false, or external package name validity
    "test_javascriptnpm_case_sensitive"
    "test_javascriptnpm_real"
    "test_javascriptnpm_stdlib"
    "test_javascriptnpm_weird"
    "test_pythonpypi_case_sensitive"
    "test_pythonpypi_pypi"
    "test_pythonpypi_stdlib"
    "test_pythonpypi_weird"
    "test_result_alignment"
    "test_rubygems_case_sensitive"
    "test_rubygems_real"
    "test_rubygems_stdlib"
    "test_rubygems_weird"
    "test_rustcrates_case_sensitive"
    "test_rustcrates_direct_usage"
    "test_rustcrates_real"
    "test_rustcrates_stdlib"
    "test_rustcrates_weird"

    # get warnings from where the test causes garak/_plugins.py:273 to try open missing files
    # e.g. /build/pytest-of-nixbld/pytest-0/test_llava_generate_returns_de0/test.png
    "test_create"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "LLM vulnerability scanner";
    homepage = "https://github.com/NVIDIA/garak";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jk ];
    mainProgram = "garak";
  };
}

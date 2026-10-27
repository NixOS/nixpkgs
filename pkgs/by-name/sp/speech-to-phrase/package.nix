{
  lib,
  bash,
  callPackage,
  diffutils,
  fetchFromGitHub,
  gawk,
  gzip,
  home-assistant,
  kaldi,
  opengrm-ngram,
  perl,
  phonetisaurus,
  runCommand,
}:

let
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "OHF-voice";
    repo = "speech-to-phrase";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-1Yj4cxFxBQdhytl8YTDbjC44veRNmLhwiRZEhsVcfS4=";
  };

  stt-onlyprobs = callPackage ./stt-onlyprobs.nix { inherit src version; };

  tools = runCommand "speech-to-phrase-tools" { } ''
    mkdir -p $out/kaldi
    ln -s ${kaldi}/{bin,lib} $out/kaldi
    cp -r ${kaldi}/share/kaldi/egs/wsj/s5/{steps,utils} $out/kaldi
    ln -s ${kaldi} $out/openfst

    ln -s ${opengrm-ngram} $out/opengrm
    # The binary phonetisaurus in the download identifies itself as phonetisaurus-g2pfst when run with --help
    ln -s ${lib.getExe' phonetisaurus "phonetisaurus-g2pfst"} $out/phonetisaurus
    ln -s ${lib.getExe stt-onlyprobs} $out/stt_onlyprobs
  '';

  inherit (home-assistant) python3Packages;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "speech-to-phrase";
  inherit version src;
  pyproject = true;

  __structuredAttrs = true;

  patches = [
    # ERROR: Fst::Write: Can't open file: -
    ./fix-stdout.diff
  ];

  postPatch = ''
    # allow us to load the home-assistant token securely
    substituteInPlace speech_to_phrase/__main__.py \
      --replace-fail 'import argparse' 'import argparse; import os' \
      --replace-fail '"--hass-token", required=True' ' "--hass-token", default=os.environ.get("HASS_TOKEN")'

    # flags in opensft changed semantics
    substituteInPlace speech_to_phrase/{transcribe_coqui_stt.py,transcribe_kaldi.py} \
      --replace-fail "--project_type=output" "--project_output=true"
  '';

  pythonRelaxDeps = true;

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    aiohttp
    hassil
    pyring-buffer
    pysilero-vad
    pyyaml
    regex
    ruamel-yaml
    unicode-rbnf
    wyoming
  ];

  pythonImportsCheck = [ "speech_to_phrase" ];

  postFixup = ''
    buildPythonPath "$out ''${pythonPath[*]}"
    # we must add way to many scripting tools to PATH to contains kaldi's scripting hell
    makeWrapper ${python3Packages.python.interpreter} $out/bin/speech-to-phrase \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          diffutils
          gawk
          gzip
          kaldi
          perl
          python3Packages.python
        ]
      } \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
      --add-flags "-m speech_to_phrase" \
      --add-flags "--tools-dir ${tools}"
  '';

  nativeCheckInputs = with python3Packages; [
    home-assistant.intents
    kaldi
    opengrm-ngram # for ngrammake
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    voluptuous
  ];

  enabledTestPaths = [
    "tests"
  ];

  disabledTestPaths = [
    # requires connecting to huggingface.co
    "tests/test_transcribe.py"

    # maybe https://github.com/OHF-Voice/speech-to-phrase/pull/129 ?
    "tests/test_validate_yaml.py::test_validate_sentences[de]"

    # broke with Home-Assistant 2026.7
    "tests/test_recognize.py::test_recognize"
  ];

  meta = {
    changelog = "https://github.com/OHF-Voice/speech-to-phrase/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/OHF-Voice/speech-to-phrase";
    description = "Fast and personalized local speech-to-text";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "speech-to-phrase";
  };
})

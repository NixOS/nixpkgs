{
  fetchFromGitHub,
  fetchpatch,
  lib,
  pandoc,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "coursera-dl";
  version = "0.11.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coursera-dl";
    repo = "coursera-dl";
    tag = version;
    hash = "sha256-c+ElGIrd4ZhMfWtsNHrHRO3HaRRtEQuGlCSBrvPnbyo=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/coursera-dl/coursera-dl/commit/c8796e567698be166cb15f54e095140c1a9b567e.patch";
      hash = "sha256-e52QPr4XH+HnB49R+nkG0KC9Zf1TbPf92dcP7ts3ih0=";
    })
    (fetchpatch {
      url = "https://github.com/coursera-dl/coursera-dl/commit/6c221706ba828285ca7a30a08708e63e3891b36f.patch";
      hash = "sha256-/AKFvBPInSq/lsz+G0jVSl/ukVgCnt66oePAb+66AjI=";
    })
    # https://github.com/coursera-dl/coursera-dl/pull/857
    (fetchpatch {
      name = "python-3.11-compatibility.patch";
      url = "https://github.com/coursera-dl/coursera-dl/commit/7b0783433b6b198fca9e51405b18386f90790892.patch";
      hash = "sha256-OpW8gqzrMyaE69qH3uGsB5TNQTYaO7pn3uJ7NU5SrcM=";
    })
  ];

  build-system = with python3.pkgs; [ setuptools ];

  nativeBuildInputs = [ pandoc ];

  pythonRelaxDeps = true;

  dependencies = with python3.pkgs; [
    attrs
    beautifulsoup4
    configargparse
    distutils
    keyring
    pyasn1
    requests
    six
    urllib3
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    mock
  ];

  disabledTests = [
    "test_get_credentials_with_keyring"
    "test_quiz_exam_to_markup_converter"
  ];

  meta = with lib; {
    description = "CLI for downloading Coursera.org videos and naming them";
    mainProgram = "coursera-dl";
    homepage = "https://github.com/coursera-dl/coursera-dl";
    changelog = "https://github.com/coursera-dl/coursera-dl/blob/${src.rev}/CHANGELOG.md";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}

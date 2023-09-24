{ lib
, fetchFromGitHub
, fetchpatch
, glibcLocales
, pandoc
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "coursera-dl";
  version = "0.11.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coursera-dl";
    repo = "coursera-dl";
    rev = "refs/tags/${version}";
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

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace '==' '>='
  '';

  preConfigure = ''
    export LC_ALL=en_US.utf-8
  '';

  nativeBuildInputs = with python3.pkgs; [
    pandoc
  ];

  buildInputs = with python3.pkgs; [
    glibcLocales
  ];

  propagatedBuildInputs = with python3.pkgs; [
    attrs
    beautifulsoup4
    configargparse
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
    homepage = "https://github.com/coursera-dl/coursera-dl";
    changelog = "https://github.com/coursera-dl/coursera-dl/blob/0.11.5/CHANGELOG.md";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ alexfmpe ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}

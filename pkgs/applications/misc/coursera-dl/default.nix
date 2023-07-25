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
    sha256 = "0akgwzrsx094jj30n4bd2ilwgva4qxx38v3bgm69iqfxi8c2bqbk";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/coursera-dl/coursera-dl/commit/c8796e567698be166cb15f54e095140c1a9b567e.patch";
      sha256 = "sha256:07ca6zdyw3ypv7yzfv2kzmjvv86h0rwzllcg0zky27qppqz917bv";
    })
    (fetchpatch {
      url = "https://github.com/coursera-dl/coursera-dl/commit/6c221706ba828285ca7a30a08708e63e3891b36f.patch";
      sha256 = "sha256-/AKFvBPInSq/lsz+G0jVSl/ukVgCnt66oePAb+66AjI=";
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

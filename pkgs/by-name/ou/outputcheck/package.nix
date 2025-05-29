{
  lib,
  python3,
  fetchFromGitHub,
  lit,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "outputcheck";
  version = "0.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "stp";
    repo = "OutputCheck";
    rev = "eab62a5dd5129f6a4ebfbe4bbe41d35611f7c48d";
    hash = "sha256-0D5Lljn66jB/EW/ntC2eTuXAt0w0cceeeqf3aKuyeF0=";
  };

  # - Fix deprecated 'U' mode in python 3.11
  #   https://github.com/python/cpython/blob/3.11/Doc/library/functions.rst?plain=1#L1386
  # - Fix expected error and actual parser error mismatch
  # - Fix version number cannot find error
  postPatch = ''
    substituteInPlace OutputCheck/Driver.py \
      --replace "argparse.FileType('rU')" "argparse.FileType('r')"

    substituteInPlace tests/invalid-regex-syntax.smt2 \
      --replace "unbalanced parenthesis" "missing ), unterminated subpattern"

    echo ${version} > RELEASE-VERSION
  '';

  nativeCheckInputs = [ lit ];

  checkPhase = ''
    runHook preCheck

    lit -v tests/

    runHook postCheck
  '';

  pythonImportsCheck = [ "OutputCheck" ];

  meta = with lib; {
    description = "Tool for checking tool output inspired by LLVM's FileCheck";
    homepage = "https://github.com/stp/OutputCheck";
    changelog = "https://github.com/stp/OutputCheck/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fsagbuya ];
    mainProgram = "OutputCheck";
  };
}

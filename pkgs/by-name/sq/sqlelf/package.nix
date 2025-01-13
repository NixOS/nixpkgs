{ lib
, stdenv
, python3Packages
, fetchPypi

# ls and cat binaries are referenced in tests
, coreutils
}:

python3Packages.buildPythonApplication rec {
  pname = "sqlelf";
  version = "0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S2D918B/zuIpoF/FBTQKMjmPLjXt11wnxXMQ5rZrp7s=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    capstone
    lief
    apsw
    sh
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  # Those tests depend on ls and cat being x86_64 Linux ELF files.
  # The x86_64 check should be relaxed once sqlelf supports other architectures.
  disabledTestPaths = lib.optionals (!stdenv.isLinux || !stdenv.isx86_64) [
    "tests/test_sql.py"
  ];

  pytestFlagsArray = [
    "-m" "not\\ slow"
  ];

  preCheck = ''
    for test in tests/*.py; do
      substituteInPlace "$test" \
        --replace "/bin/ls" "${lib.getExe' coreutils "ls"}" \
        --replace "/bin/cat" "${lib.getExe' coreutils "cat"}"
    done
  '';

  meta = with lib; {
    mainProgram = "sqlelf";
    changelog = "https://github.com/fzakaria/sqlelf/releases/tag/v${version}";
    description = "Explore ELF objects through the power of SQL";
    homepage = "https://github.com/fzakaria/sqlelf";
    license = licenses.mit;
    maintainers = with maintainers; [ nrabulinski ];
  };
}

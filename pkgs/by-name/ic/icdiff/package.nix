{
  lib,
  python3Packages,
  fetchFromGitHub,
  bash,
  git,
  less,
}:

python3Packages.buildPythonApplication rec {
  pname = "icdiff";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "jeffkaufman";
    repo = "icdiff";
    tag = "release-${version}";
    hash = "sha256-XOw/xhPGlzi1hAgzQ1EtioUM476A+lQWLlvvaxd9j08=";
  };

  # error: could not lock config file /homeless-shelter/.gitconfig: No such file or directory
  doCheck = false;

  nativeCheckInputs = [
    bash
    git
    less
  ];

  checkPhase = ''
    patchShebangs test.sh
    ./test.sh ${python3Packages.python.interpreter}
  '';

  meta = {
    homepage = "https://www.jefftk.com/icdiff";
    description = "Side-by-side highlighted command line diffs";
    maintainers = [ ];
    license = lib.licenses.psfl;
  };
}

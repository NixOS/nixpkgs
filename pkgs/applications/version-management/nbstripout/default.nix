{lib, python, git, mercurial, coreutils}:

with python.pkgs;
buildPythonApplication rec {
  version = "0.3.6";
  pname = "nbstripout";

  # Mercurial should be added as a build input but because it's a Python
  # application, it would mess up the Python environment. Thus, don't add it
  # here, instead add it to PATH when running unit tests
  checkInputs = [ pytest pytest-flake8 git ];
  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ ipython nbformat ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x6010akw7iqxn7ba5m6malfr2fvaf0bjp3cdh983qn1s7vwlq0r";
  };

  # for some reason, darwin uses /bin/sh echo native instead of echo binary, so
  # force using the echo binary
  postPatch = ''
    substituteInPlace tests/test-git.t --replace "echo" "${coreutils}/bin/echo"
  '';

  # ignore flake8 tests for the nix wrapped setup.py
  checkPhase = ''
    PATH=$PATH:$out/bin:${mercurial}/bin pytest .
  '';

  meta = {
    inherit version;
    description = "Strip output from Jupyter and IPython notebooks";
    homepage = https://github.com/kynan/nbstripout;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}

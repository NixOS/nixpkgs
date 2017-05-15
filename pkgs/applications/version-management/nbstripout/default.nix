{lib, python2Packages, git, mercurial}:

with python2Packages;
buildPythonApplication rec {
  name = "${pname}-${version}";
  version = "0.3.0";
  pname = "nbstripout";

  # Mercurial should be added as a build input but because it's a Python
  # application, it would mess up the Python environment. Thus, don't add it
  # here, instead add it to PATH when running unit tests
  buildInputs = [ pytest pytest-flake8 pytest-cram git pytestrunner ];
  propagatedBuildInputs = [ ipython nbformat ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "126xhjma4a0k7gq58hbqglhb3rai0a576azz7g8gmqjr3kl0264v";
  };

  # ignore flake8 tests for the nix wrapped setup.py
  checkPhase = ''
    PATH=$PATH:$out/bin:${mercurial}/bin pytest --ignore=nix_run_setup.py .
  '';

  meta = {
    inherit version;
    description = "Strip output from Jupyter and IPython notebooks";
    homepage = https://github.com/kynan/nbstripout;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}

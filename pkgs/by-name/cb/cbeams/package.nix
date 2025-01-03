{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "cbeams";
  version = "1.0.3";
  pyproject = true;

  disabled = !python3Packages.isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Q2sWsAc39Mu34K1wWOKOJERKzBStE4GmtuzOs2T7Kk=";
  };

  build-system = [ python3Packages.setuptools ];

  postPatch = ''
    substituteInPlace cbeams/terminal.py \
      --replace-fail "blessings" "blessed"
  '';

  pythonRemoveDeps = [ "blessings" ];

  dependencies = with python3Packages; [
    blessed
    docopt
  ];

  doCheck = false; # no tests

  meta = {
    homepage = "https://github.com/tartley/cbeams";
    description = "Command-line program to draw animated colored circles in the terminal";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      oxzi
      sigmanificient
    ];
  };
}

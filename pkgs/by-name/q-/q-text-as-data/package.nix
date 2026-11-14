{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "q-text-as-data";
  version = "2.0.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "harelba";
    repo = "q";
    rev = finalAttrs.version;
    hash = "sha256-W5O8I8eP9oInneRi+8L9eyE2SFp1IdA8ZVv1/qTznKE=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    six
  ];

  doCheck = false;

  patchPhase = ''
    # remove broken symlink
    rm bin/qtextasdata.py

    # not considered good practice pinning in install_requires
    substituteInPlace setup.py --replace-fail 'six==' 'six>='
  '';

  meta = {
    description = "Run SQL directly on CSV or TSV files";
    longDescription = ''
      q is a command line tool that allows direct execution of SQL-like queries on CSVs/TSVs (and any other tabular text files).

      q treats ordinary files as database tables, and supports all SQL constructs, such as WHERE, GROUP BY, JOINs etc. It supports automatic column name and column type detection, and provides full support for multiple encodings.
    '';
    homepage = "http://harelba.github.io/q/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.taneb ];
    platforms = lib.platforms.all;
    mainProgram = "q";
  };
})

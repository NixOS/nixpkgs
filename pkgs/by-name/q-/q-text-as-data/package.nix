{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "q-text-as-data";
  version = "2.0.19";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "harelba";
    repo = "q";
    rev = version;
    sha256 = "18cwyfjgxxavclyd08bmb943c8bvzp1gnqp4klkq5xlgqwivr4sv";
  };

  propagatedBuildInputs = with python3Packages; [
    setuptools
    six
  ];

  doCheck = false;

  patchPhase = ''
    # remove broken symlink
    rm bin/qtextasdata.py

    # not considered good practice pinning in install_requires
    substituteInPlace setup.py --replace 'six==' 'six>='
  '';

  meta = with lib; {
    description = "Run SQL directly on CSV or TSV files";
    longDescription = ''
      q is a command line tool that allows direct execution of SQL-like queries on CSVs/TSVs (and any other tabular text files).

      q treats ordinary files as database tables, and supports all SQL constructs, such as WHERE, GROUP BY, JOINs etc. It supports automatic column name and column type detection, and provides full support for multiple encodings.
    '';
    homepage = "http://harelba.github.io/q/";
    license = licenses.gpl3;
    maintainers = [ maintainers.taneb ];
    platforms = platforms.all;
    mainProgram = "q";
  };
}

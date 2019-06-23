{ stdenv, python3, notmuch }:

python3.pkgs.buildPythonApplication rec {
  pname = "mlarchive2maildir";
  version = "0.0.6";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "025mv890zsk25cral9cas3qgqdsszh5025khz473zs36innjd0mw";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools_scm ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    click
    click-log
    requests
    six
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/flokli/mlarchive2maildir;
    description = "Imports mail from (pipermail) archives into a maildir";
    license = licenses.mit;
    maintainers = with maintainers; [ andir flokli ];
  };
}

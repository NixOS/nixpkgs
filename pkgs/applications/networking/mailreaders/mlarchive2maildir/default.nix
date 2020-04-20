{ stdenv, python3, notmuch }:

python3.pkgs.buildPythonApplication rec {
  pname = "mlarchive2maildir";
  version = "0.0.8";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1din3yay2sas85178v0xr0hbm2396y4dalkcqql1ny9vdm94h6sp";
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
    homepage = "https://github.com/flokli/mlarchive2maildir";
    description = "Imports mail from (pipermail) archives into a maildir";
    license = licenses.mit;
    maintainers = with maintainers; [ andir flokli ];
  };
}

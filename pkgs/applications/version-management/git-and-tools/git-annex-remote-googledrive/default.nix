#{ stdenv, pythonPackages, fetchPypi, rclone, makeWrapper }:
{ stdenv, lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "git-annex-remote-googledrive";
  version = "0.11.1";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1vaycxmxhx8g797nzrnkmz5vbmjy4x7x3b7a2xb7yz6grgcxqgld";
  };

  buildInputs = [ ];
  propagatedBuildInputs = [ python3.pkgs.pydrive python3.pkgs.annexremote python3.pkgs.tenacity ];

  meta = with stdenv.lib; {
    description = "Git annex remote for GoogleDrive";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ poelzi ];
  };

}

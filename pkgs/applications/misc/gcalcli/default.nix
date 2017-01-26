{ stdenv, fetchFromGitHub, pkgs, lib, python, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "4.0.0a2";
  name = "gcalcli-${version}";

  src = fetchFromGitHub {
    owner = "insanum";
    repo = "gcalcli";
    rev = "v${version}";
    sha256 = "0cw6985ixd3lndjb90ds7q4r4wwl7crljjsw2cl3dhrn029w885i";
  };

  propagatedBuildInputs = with pythonPackages; [
    dateutil
    gflags
    google_api_python_client
    parsedatetime
    six
    vobject
  ] ++ lib.optional (!pythonPackages.isPy3k) futures;

  meta = with lib; {
    homepage = https://github.com/insanum/gcalcli;
    description = "Google Calendar Command Line Interface";
    license = licenses.mit;
  };
}

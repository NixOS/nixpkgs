{ fetchFromGitHub, lib, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "3.4.0";
  name = "gcalcli-${version}";

  src = fetchFromGitHub {
    owner = "insanum";
    repo = "gcalcli";
    rev = "v${version}";
    sha256 = "171awccgnmfv4j7m2my9387sjy60g18kzgvscl6pzdid9fn9rrm8";
  };

  propagatedBuildInputs = with pythonPackages; [
    dateutil
    gflags
    google_api_python_client
    httplib2
    oauth2client
    parsedatetime
    six
    vobject
  ] ++ lib.optional (!pythonPackages.isPy3k) futures;

  meta = with lib; {
    homepage = https://github.com/insanum/gcalcli;
    description = "CLI for Google Calendar";
    license = licenses.mit;
    maintainers = [ maintainers.nocoolnametom ];
  };
}

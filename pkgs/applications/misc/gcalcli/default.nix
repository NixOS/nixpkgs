{ stdenv, lib, fetchFromGitHub, pythonPackages
, libnotify ? null }:

pythonPackages.buildPythonApplication rec {
  version = "3.4.0";
  name = "gcalcli-${version}";

  src = fetchFromGitHub {
    owner  = "insanum";
    repo   = "gcalcli";
    rev    = "v${version}";
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
  ]
  ++ lib.optional (!pythonPackages.isPy3k) futures;

  # there are no tests as of 3.4.0
  doCheck = false;

  postInstall = lib.optionalString stdenv.isLinux ''
    substituteInPlace $out/bin/gcalcli \
      --replace "command = 'notify-send -u critical -a gcalcli %s'" \
                "command = '${libnotify}/bin/notify-send -i view-calendar-upcoming-events -u critical -a Calendar %s'"
  '';

  meta = with lib; {
    homepage = https://github.com/insanum/gcalcli;
    description = "CLI for Google Calendar";
    license = licenses.mit;
    maintainers = with maintainers; [ nocoolnametom ];
    inherit version;
  };
}

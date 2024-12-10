{
  stdenv,
  lib,
  fetchFromGitHub,
  python3,
  libnotify ? null,
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "gcalcli";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "insanum";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s5fhcmz3n0dwh3vkqr4aigi59q43v03ch5jhh6v75149icwr0df";
  };

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace gcalcli/argparsers.py \
      --replace "'notify-send" "'${libnotify}/bin/notify-send"
  '';

  propagatedBuildInputs = [
    python-dateutil
    gflags
    httplib2
    parsedatetime
    six
    vobject
    google-api-python-client
    oauth2client
    uritemplate
    libnotify
  ];

  # There are no tests as of 4.0.0a4
  doCheck = false;

  meta = with lib; {
    description = "CLI for Google Calendar";
    mainProgram = "gcalcli";
    homepage = "https://github.com/insanum/gcalcli";
    license = licenses.mit;
    maintainers = with maintainers; [ nocoolnametom ];
  };
}

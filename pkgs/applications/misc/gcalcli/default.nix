{ stdenv, lib, fetchFromGitHub, python3
, libnotify ? null }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "gcalcli";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner  = "insanum";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0746vmhfclkpkqnyaidxid2z20mlv86hv0pjxy1qglrja91vkd72";
  };

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace gcalcli/argparsers.py \
      --replace "'notify-send" "'${libnotify}/bin/notify-send"
  '';

  propagatedBuildInputs = [
    dateutil gflags httplib2 parsedatetime six vobject
    google_api_python_client oauth2client uritemplate
    libnotify
  ] ++ lib.optional (!isPy3k) futures;

  # There are no tests as of 4.0.0a4
  doCheck = false;

  meta = with lib; {
    description = "CLI for Google Calendar";
    homepage = https://github.com/insanum/gcalcli;
    license = licenses.mit;
    maintainers = with maintainers; [ nocoolnametom ];
    inherit version;
  };
}

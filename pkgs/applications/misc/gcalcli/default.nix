{ stdenv, lib, fetchFromGitHub, python3
, libnotify ? null }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "gcalcli";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner  = "insanum";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "15hpm7b09p5qnha0hpp0mgdl2pgsyq2sjcqihk3fsv7arngdbr5q";
  };

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace gcalcli/argparsers.py --replace \
      "command = 'notify-send -u critical" \
      "command = '${libnotify}/bin/notify-send -u critical"
  '';

  propagatedBuildInputs = [
    dateutil gflags httplib2 parsedatetime six vobject
    google_api_python_client oauth2client uritemplate
  ] ++ lib.optional (!isPy3k) futures;

  postInstall = lib.optionalString stdenv.isLinux ''
    substituteInPlace $out/bin/gcalcli --replace \
      "command = 'notify-send -u critical -a gcalcli %s'" \
      "command = '${libnotify}/bin/notify-send -i view-calendar-upcoming-events -u critical -a Calendar %s'"
  '';

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

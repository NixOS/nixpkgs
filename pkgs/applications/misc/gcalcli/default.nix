{ stdenv, lib, fetchFromGitHub, python2
, libnotify ? null }:

let
  py = python2.override {
    packageOverrides = self: super: {
      google_api_python_client = super.google_api_python_client.overridePythonAttrs (oldAttrs: rec {
        version = "1.5.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1ggxk094vqr4ia6yq7qcpa74b4x5cjd5mj74rq0xx9wp2jkrxmig";
        };
      });

      oauth2client = super.oauth2client.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.12";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0phfk6s8bgpap5xihdk1xv2lakdk1pb3rg6hp2wsg94hxcxnrakl";
        };
      });

      uritemplate = super.uritemplate.overridePythonAttrs (oldAttrs: rec {
        version = "0.6";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1zapwg406vkwsirnzc6mwq9fac4az8brm6d9bp5xpgkyxc5263m3";
        };
        # there are no checks in this version
        doCheck = false;
      });
    };
  };

in with py.pkgs; buildPythonApplication rec {
  version = "3.4.0";
  name = "gcalcli-${version}";

  src = fetchFromGitHub {
    owner  = "insanum";
    repo   = "gcalcli";
    rev    = "v${version}";
    sha256 = "171awccgnmfv4j7m2my9387sjy60g18kzgvscl6pzdid9fn9rrm8";
  };

  propagatedBuildInputs = [
    dateutil gflags httplib2 parsedatetime six vobject
    # overridden
    google_api_python_client oauth2client uritemplate
  ] ++ lib.optional (!isPy3k) futures;

  postInstall = lib.optionalString stdenv.isLinux ''
    substituteInPlace $out/bin/gcalcli --replace \
      "command = 'notify-send -u critical -a gcalcli %s'" \
      "command = '${libnotify}/bin/notify-send -i view-calendar-upcoming-events -u critical -a Calendar %s'"
  '';

  # There are no tests as of 3.4.0
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/insanum/gcalcli;
    description = "CLI for Google Calendar";
    license = licenses.mit;
    maintainers = with maintainers; [ nocoolnametom ];
    inherit version;
  };
}

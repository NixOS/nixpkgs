{ stdenv, substituteAll, buildEnv, fetchFromGitHub, pythonPackages }:

stdenv.mkDerivation rec {
  name = "wee-slack-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    repo = "wee-slack";
    owner = "wee-slack";
    rev = "v${version}";
    sha256 = "1iy70q630cgs7fvk2151fq9519dwxrlqq862sbrwypzr6na6yqpg";
  };

  patches = [
    (substituteAll {
      src = ./libpath.patch;
      env = "${buildEnv {
        name = "wee-slack-env";
        paths = with pythonPackages; [ websocket_client six ];
      }}/${pythonPackages.python.sitePackages}";
    })
  ];

  passthru.scripts = [ "wee_slack.py" ];

  installPhase = ''
    mkdir -p $out/share
    cp wee_slack.py $out/share/wee_slack.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/wee-slack/wee-slack;
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    description = ''
      A WeeChat plugin for Slack.com. Synchronizes read markers, provides typing notification, search, etc..
    '';
  };
}

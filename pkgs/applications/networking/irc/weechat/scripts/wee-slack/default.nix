{ stdenv, substituteAll, buildEnv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  pname = "wee-slack";
  version = "2.4.0";

  src = fetchFromGitHub {
    repo = "wee-slack";
    owner = "wee-slack";
    rev = "v${version}";
    sha256 = "0h425ln5vv76zv41dccapyfbl8qmmflbpwmrd26knqyj8k24zfpr";
  };

  patches = [
    (substituteAll {
      src = ./libpath.patch;
      env = "${buildEnv {
        name = "wee-slack-env";
        paths = with python3Packages; [ websocket_client six ];
      }}/${python3Packages.python.sitePackages}";
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
    maintainers = with maintainers; [ willibutz ];
    description = ''
      A WeeChat plugin for Slack.com. Synchronizes read markers, provides typing notification, search, etc..
    '';
  };
}

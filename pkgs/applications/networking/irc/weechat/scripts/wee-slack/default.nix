{ lib, stdenv, substituteAll, buildEnv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  pname = "wee-slack";
  version = "2.9.0";

  src = fetchFromGitHub {
    repo = "wee-slack";
    owner = "wee-slack";
    rev = "v${version}";
    sha256 = "sha256-WMZo+X8G/Dnl1Vv0LuBYcvxdfll9cy/3Z/fpNJSxCQY=";
  };

  patches = [
    (substituteAll {
      src = ./libpath.patch;
      env = "${buildEnv {
        name = "wee-slack-env";
        paths = with python3Packages; [
          websocket-client
          six
        ];
      }}/${python3Packages.python.sitePackages}";
    })
    ./load_weemoji_path.patch
  ];

  postPatch = ''
    substituteInPlace wee_slack.py --subst-var out
  '';

  passthru.scripts = [ "wee_slack.py" ];

  installPhase = ''
    mkdir -p $out/share
    cp wee_slack.py $out/share/wee_slack.py
    install -D -m 0444 weemoji.json $out/share/wee-slack/weemoji.json
  '';

  meta = with lib; {
    homepage = "https://github.com/wee-slack/wee-slack";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    description = ''
      A WeeChat plugin for Slack.com. Synchronizes read markers, provides typing notification, search, etc..
    '';
  };
}

{ lib, stdenv, substituteAll, buildEnv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  pname = "wee-slack";
<<<<<<< HEAD
  version = "2.10.0";
=======
  version = "2.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    repo = "wee-slack";
    owner = "wee-slack";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-SxmMCD7FdkmZ0ccDbuY2XUGcLxHlv62x4Pj55Wzf0AA=";
=======
    sha256 = "sha256-f5CRJmvNZlKOE1XsU214R42dYo0s5xSRXC8TKOniEf4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

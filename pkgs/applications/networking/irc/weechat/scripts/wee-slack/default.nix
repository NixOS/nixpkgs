{
  lib,
  stdenv,
  replaceVars,
  buildEnv,
  fetchFromGitHub,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "wee-slack";
  version = "2.11.0";

  src = fetchFromGitHub {
    repo = "wee-slack";
    owner = "wee-slack";
    rev = "v${version}";
    sha256 = "sha256-xQO/yi4pJSnO/ldzVQkC7UhAfpy57xzO58NV7KZm4E8=";
  };

  patches = [
    (replaceVars ./libpath.patch {
      env = "${
        buildEnv {
          name = "wee-slack-env";
          paths = with python3Packages; [
            websocket-client
            six
          ];
        }
      }/${python3Packages.python.sitePackages}";
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
    maintainers = [ ];
    description = ''
      A WeeChat plugin for Slack.com. Synchronizes read markers, provides typing notification, search, etc..
    '';
  };
}

{
  lib,
  stdenv,
  replaceVars,
  buildEnv,
  fetchFromGitHub,
  python3Packages,
}:

stdenv.mkDerivation {
  pname = "wee-slack";
  version = "2.11.0-unstable-2026-01-07";

  src = fetchFromGitHub {
    repo = "wee-slack";
    owner = "wee-slack";
    rev = "08a9cd05d482772e79d879e0b99ddd66a94d979d";
    hash = "sha256-9S8XI+ZSzXcWOQbH6hxZ3N8VEczRE0+xxh5w9dqTL00=";
  };

  patches = [
    (replaceVars ./libpath.patch {
      env = "${
        buildEnv {
          name = "wee-slack-env";
          paths = with python3Packages; [
            websocket-client
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

  meta = {
    homepage = "https://github.com/wee-slack/wee-slack";
    license = lib.licenses.mit;
    maintainers = [ ];
    description = ''
      A WeeChat plugin for Slack.com. Synchronizes read markers, provides typing notification, search, etc..
    '';
  };
}

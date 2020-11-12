{ stdenv, substituteAll, buildEnv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  pname = "wee-slack";
  version = "8bd734c8e9a6b133a65548672f8a11ee3b3ce677";

  src = fetchFromGitHub {
    repo = "wee-slack";
    owner = "wee-slack";
    rev = version;
    sha256 = "0p48cpaqfqja9i68dqyladwif7x8c19ii8v27p9cxz5y9impc9qk";
  };

  patches = [
    (substituteAll {
      src = ./libpath.patch;
      env = "${buildEnv {
        name = "wee-slack-env";
        paths = with python3Packages; [ websocket_client six ];
      }}/${python3Packages.python.sitePackages}";
    })
    ./0001-hardcode-json-file-path.patch
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/wee-slack/wee-slack";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    description = ''
      A WeeChat plugin for Slack.com. Synchronizes read markers, provides typing notification, search, etc..
    '';
  };
}

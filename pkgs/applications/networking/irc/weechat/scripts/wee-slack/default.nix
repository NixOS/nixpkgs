{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "wee-slack-${version}";
  version = "2.1.1";

  src = fetchFromGitHub {
    repo = "wee-slack";
    owner = "wee-slack";
    rev = "v${version}";
    sha256 = "05caackz645aw6kljmiihiy7xz9jld8b9blwpmh0cnaihavgj1wc";
  };

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

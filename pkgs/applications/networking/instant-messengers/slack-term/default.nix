{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  # https://github.com/erroneousboat/slack-term
  name = "slack-term-${version}";
  version = "0.4.1";

  goPackagePath = "github.com/erroneousboat/slack-term";

  src = fetchFromGitHub {
    owner = "erroneousboat";
    repo = "slack-term";
    rev = "v${version}";
    sha256 = "1340bq7h31fxykxbxpn6hv7n2hmjf20f8vg5gan9pjf5jaa6kfza";
  };

  meta = with stdenv.lib; {
    description = "Slack client for your terminal";
    homepage = https://github.com/erroneousboat/slack-term;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}

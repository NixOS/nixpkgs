{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "slack-term";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "erroneousboat";
    repo = "slack-term";
    rev = "v${version}";
    sha256 = "1fbq7bdhy70hlkklppimgdjamnk0v059pg73xm9ax1f4616ki1m6";
  };
  vendorHash = null;

<<<<<<< HEAD
  meta = {
    description = "Slack client for your terminal";
    homepage = "https://github.com/erroneousboat/slack-term";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Slack client for your terminal";
    homepage = "https://github.com/erroneousboat/slack-term";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "slack-term";
  };
}

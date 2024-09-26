{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "slack-term";
  version = "0.5.0-master";

  src = fetchFromGitHub {
    owner = "erroneousboat";
    repo = "slack-term";
    rev = "c19c20a3e5c597d6d60582fcba1a3523415e8fe4";
    sha256 = "D+3qpRJkADTZyDxQQSFFKZz2WVQIaR8fzS7S90vMlLk=";
  };
  vendorHash = null;

  meta = with lib; {
    description = "Slack client for your terminal";
    homepage = "https://github.com/erroneousboat/slack-term";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "slack-term";
  };
}

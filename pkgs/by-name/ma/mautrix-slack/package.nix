{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule {
  pname = "mautrix-slack";
  version = "unstable-2024-03-19";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    rev = "a9ba2f9249bdc5df69a1349122d1769e7e48c9e1";
    hash = "sha256-NE/YsiYm6t/6LNilATIvk0CcOFiQAqgw533WyhMZgvQ=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-FL0wObZIvGV9V7pLmrxTILQ/TGEMSH8/2wFPlu6idcA=";

  # There are no tests in mautrix-slack.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mautrix/slack";
    description = " A Matrix-Slack puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
    mainProgram = "mautrix-slack";
  };
}

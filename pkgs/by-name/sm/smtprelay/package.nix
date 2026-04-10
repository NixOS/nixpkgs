{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "smtprelay";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "decke";
    repo = "smtprelay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CKE0KYzLBp3nS4gIUqQ1jyu9c4uBi3x9WcLA1zxTemY=";
  };

  vendorHash = "sha256-kiFPTm46Ws3orwmm/pIz8amcYOq7038exLQ5fU9QqI8=";

  subPackages = [
    "."
  ];

  env.CGO_ENABLED = 0;

  # We do not supply the build time as the build wouldn't be reproducible otherwise.
  ldflags = [
    "-s"
    "-w"
    "-X=main.appVersion=v${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/decke/smtprelay";
    description = "Simple Golang SMTP relay/proxy server";
    mainProgram = "smtprelay";
    changelog = "https://github.com/decke/smtprelay/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juliusrickert ];
  };
})

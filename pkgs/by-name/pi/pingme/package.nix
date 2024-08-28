{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pingme";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "kha7iq";
    repo = "pingme";
    rev = "v${version}";
    hash = "sha256-i+EZ3HfuxHSuZDe0+nfZVvoNZN5XcdQFwfgOg4OLBOs=";
  };

  vendorHash = "sha256-fEJII8qSDIbMNhRfuYUsRA1AmOXR27iHpBPNCDFI4xQ=";

  # bump go version
  preBuild = ''
    substituteInPlace go.mod \
      --replace-fail 'go 1.16' 'go 1.21'
    go mod tidy
  '';
  proxyVendor = true;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = {
    changelog = "https://github.com/kha7iq/pingme/releases/tag/${src.rev}";
    description = "Send messages or alerts to multiple messaging platforms & email";
    homepage = "https://pingme.lmno.pk";
    license = lib.licenses.mit;
    mainProgram = "pingme";
    maintainers = with lib.maintainers; [ emilytrau ];
  };
}

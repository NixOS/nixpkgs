{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "MailHog";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mailhog";
    repo = "MailHog";
    rev = "v${version}";
    hash = "sha256-flxEp9iXLLm/FPP8udlnpbHQpGnqxAhgyOIUUJAJgog=";
  };

  patches = [
    # Generate by go mod init github.com/mailhog/MailHog && go mod tidy
    ./0001-Add-go.mod-go.sum.patch
  ];

  vendorHash = "sha256-yYMgNpthBwmDeD4pgnVj88OJWiPNWuwzxDzC6eejabU=";

  deleteVendor = true;

  ldflags = [
    "-s"
    "-X main.version=${version}"
  ];

  passthru.tests = {
    inherit (nixosTests) mailhog;
  };

  meta = with lib; {
    description = "Web and API based SMTP testing";
    mainProgram = "MailHog";
    homepage = "https://github.com/mailhog/MailHog";
    changelog = "https://github.com/mailhog/MailHog/releases/tag/v${version}";
    maintainers = with maintainers; [
      disassembler
      jojosch
    ];
    license = licenses.mit;
  };
}

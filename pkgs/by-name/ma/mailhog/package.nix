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
    # Generate by go mod init github.com/mailhog/MailHog && go mod tidy && go get github.com/mailhog/mhsendmail@9e70164f299c9e06af61402e636f5bbdf03e7dbb
    ./0001-Add-go.mod-go.sum.patch
  ];

  vendorHash = "sha256-YfqC8MEdiLcucOaXOsLI9H4NDQ/4T0newb6q7v0uDbw=";

  deleteVendor = true;

  ldflags = [
    "-s"
    "-X main.version=${version}"
  ];

  passthru.tests = {
    inherit (nixosTests) mailhog;
  };

  meta = {
    description = "Web and API based SMTP testing";
    mainProgram = "MailHog";
    homepage = "https://github.com/mailhog/MailHog";
    changelog = "https://github.com/mailhog/MailHog/releases/tag/v${version}";
    maintainers = with lib.maintainers; [
      disassembler
      jojosch
    ];
    license = lib.licenses.mit;
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "olm";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = version;
    hash = "sha256-zUqKfrtNx6XmMSJHAfc1/ht3nPR5xy1BIijMT6u2+s8=";
  };

  vendorHash = "sha256-mY/JE26/nug9cg4hPp7hgIoKf8ORnVlDDzVw3ioBj2s=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/olm";
    changelog = "https://github.com/fosrl/olm/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      sigmasquadron
    ];
    mainProgram = "olm";
  };
}

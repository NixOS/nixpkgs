{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "postmoogle";
  version = "0.9.27";

  src = fetchFromGitHub {
    owner = "etkecc";
    repo = "postmoogle";
    tag = "v${version}";
    hash = "sha256-bifAuysOdkXnXRMYQv8pktY0NK5zUXovJJvinjsbPXQ=";
  };

  tags = [
    "timetzdata"
    "goolm"
  ];

  vendorHash = null;

  meta = {
    description = "Matrix <-> Email bridge in the form of an SMTP server";
    homepage = "https://github.com/etkecc/postmoogle";
    changelog = "https://github.com/etkecc/postmoogle/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ amuckstot30 ];
    mainProgram = "postmoogle";
  };
}

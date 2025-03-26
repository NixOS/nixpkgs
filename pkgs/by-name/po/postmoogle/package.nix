{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "postmoogle";
  version = "0.9.26";

  src = fetchFromGitHub {
    owner = "etkecc";
    repo = "postmoogle";
    tag = "v${version}";
    hash = "sha256-nbkPwHMQTadflHE8q525cB4cgVNxldOMBi4Kwrp52rE=";
  };

  tags = [
    "timetzdata"
    "goolm"
  ];

  vendorHash = null;

  meta = with lib; {
    description = "Postmoogle is Matrix <-> Email bridge in a form of an SMTP server";
    homepage = "https://github.com/etkecc/postmoogle";
    changelog = "https://github.com/etkecc/postmoogle/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ amuckstot30 ];
    mainProgram = "postmoogle";
  };
}

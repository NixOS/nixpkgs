{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "postmoogle";
  version = "0.9.25";

  src = fetchFromGitHub {
    owner = "etkecc";
    repo = "postmoogle";
    tag = "v${version}";
    hash = "sha256-Pn+IHqHvKo1936Pw8WI2IhporIy/sIvh8PAUt0y5niU=";
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

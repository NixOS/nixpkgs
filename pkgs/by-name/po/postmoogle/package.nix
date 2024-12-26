{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "postmoogle";
  version = "0.9.24";

  src = fetchFromGitHub {
    owner = "etkecc";
    repo = "postmoogle";
    rev = "refs/tags/v${version}";
    hash = "sha256-6KxPsg1zy8Dpo0UcgEWRmH6bI5oKJyzkZTelgk3SjoY=";
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

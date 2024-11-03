{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "postmoogle";
  version = "0.9.21";

  src = fetchFromGitHub {
    owner = "etkecc";
    repo = "postmoogle";
    rev = "refs/tags/v${version}";
    hash = "sha256-/AuxrIvxoKb08uf4EOYXorl7vJ99KgEH9DZYLidDzI4=";
  };

  tags = [
    "timetzdata"
    "goolm"
  ];

  vendorHash = null;

  postInstall = ''
    mv $out/bin/cmd $out/bin/postmoogle
  '';

  meta = with lib; {
    description = "Postmoogle is Matrix <-> Email bridge in a form of an SMTP server";
    homepage = "https://github.com/etkecc/postmoogle";
    changelog = "https://github.com/etkecc/postmoogle/releases/tag/v0.9.21";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ amuckstot30 ];
    mainProgram = "postmoogle";
  };
}

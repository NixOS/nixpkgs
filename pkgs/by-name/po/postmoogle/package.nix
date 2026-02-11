{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "postmoogle";
  version = "0.9.28";

  src = fetchFromGitHub {
    owner = "etkecc";
    repo = "postmoogle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vov/s2HTN/kJgwZ2AxbeWrVllcGxr6WI1EI24ea3Nl8=";
  };

  tags = [
    "timetzdata"
    "goolm"
  ];

  vendorHash = null;

  meta = {
    description = "Matrix <-> Email bridge in the form of an SMTP server";
    homepage = "https://github.com/etkecc/postmoogle";
    changelog = "https://github.com/etkecc/postmoogle/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ amuckstot30 ];
    mainProgram = "postmoogle";
  };
})

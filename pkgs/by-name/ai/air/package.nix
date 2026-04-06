{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "air";
  version = "1.65.0";

  src = fetchFromGitHub {
    owner = "air-verse";
    repo = "air";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pqvnX/PiipZM8jLBN6zN/yVnuCCk+aTII5AH0N4nHEM=";
  };

  vendorHash = "sha256-03xZ3P/7xjznYdM9rv+8ZYftQlnjJ6ZTq0HdSvGpaWw=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.airVersion=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  meta = {
    description = "Live reload for Go apps";
    mainProgram = "air";
    homepage = "https://github.com/air-verse/air";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Gonzih ];
  };
})

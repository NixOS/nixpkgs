{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "air";
  version = "1.64.4";

  src = fetchFromGitHub {
    owner = "air-verse";
    repo = "air";
    tag = "v${version}";
    hash = "sha256-m2NIRf/dZQKB3IeEChEBfJ7GJkxiyuWSRvMoHfbsLeI=";
  };

  vendorHash = "sha256-03xZ3P/7xjznYdM9rv+8ZYftQlnjJ6ZTq0HdSvGpaWw=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.airVersion=${version}"
  ];

  subPackages = [ "." ];

  meta = {
    description = "Live reload for Go apps";
    mainProgram = "air";
    homepage = "https://github.com/air-verse/air";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Gonzih ];
  };
}

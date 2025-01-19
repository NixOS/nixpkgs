{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "air";
  version = "1.61.5";

  src = fetchFromGitHub {
    owner = "air-verse";
    repo = "air";
    rev = "v${version}";
    hash = "sha256-QKNXEIMsw3MCfPg3Er9r3ncN6dxI2UsD7G/FcBIrP+Y=";
  };

  vendorHash = "sha256-tct0bWTvZhHslqPAe8uOwBx4z6gLAq57igcbV1tg9OU=";

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

{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  version = "0.4.0";
in
buildGoModule {
  pname = "gh-eco";
  inherit version;

  src = fetchFromGitHub {
    owner = "jrnxf";
    repo = "gh-eco";
    tag = "v${version}";
    hash = "sha256-kTHLhrsTzTi9eEi0S3q/kEmqaQPQHpR3OcKQWTOjFYY=";
  };

  vendorHash = "sha256-HwUAeAq6gi9PWnx2Y60K2U8vwFesJbgaDRaICGaScPc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = {
    homepage = "https://github.com/coloradocolby/gh-eco";
    description = "gh extension to explore the ecosystem";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ helium ];
    mainProgram = "gh-eco";
  };
}

{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "f2";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "ayoisaiah";
    repo = "f2";
    rev = "v${version}";
    sha256 = "sha256-AjuWaSEP2X3URZBPD05laV32ms/pULooSQKXUz8sqsU=";
  };

  vendorHash = "sha256-xKw9shfAtRjD0f4BGALM5VPjGOaYz1IqXWcctHcV/p8=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  # has no tests
  doCheck = false;

  meta = {
    description = "Command-line batch renaming tool";
    homepage = "https://github.com/ayoisaiah/f2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "f2";
  };
}

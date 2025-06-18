{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "air";
  version = "1.62.0";

  src = fetchFromGitHub {
    owner = "air-verse";
    repo = "air";
    rev = "v${version}";
    hash = "sha256-egduQyC/f8La39pWvVfDuQ2l5oRz5ZPiCqH8wAAS1OA=";
  };

  vendorHash = "sha256-ESrIn06Uhmq4qP1fdgIcao6ha1ZCqeu3cxJ1vvjRNKk=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.airVersion=${version}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Live reload for Go apps";
    mainProgram = "air";
    homepage = "https://github.com/air-verse/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "air";
  version = "1.63.0";

  src = fetchFromGitHub {
    owner = "air-verse";
    repo = "air";
    tag = "v${version}";
    hash = "sha256-S8ARa6vZzKQTUhGt2eEdRDXCFyspSNLdGqhlIy0RjDc=";
  };

  vendorHash = "sha256-1HUWdJc2YaLtszAswQTWn3bevDFJwY5xTCMlYM8j+GU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.airVersion=${version}"
  ];

  subPackages = [ "." ];

<<<<<<< HEAD
  meta = {
    description = "Live reload for Go apps";
    mainProgram = "air";
    homepage = "https://github.com/air-verse/air";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Gonzih ];
=======
  meta = with lib; {
    description = "Live reload for Go apps";
    mainProgram = "air";
    homepage = "https://github.com/air-verse/air";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Gonzih ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

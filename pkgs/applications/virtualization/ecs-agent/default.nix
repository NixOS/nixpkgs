{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "amazon-ecs-agent";
<<<<<<< HEAD
  version = "1.75.0";
=======
  version = "1.71.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aws";
    repo = pname;
<<<<<<< HEAD
    hash = "sha256-pjBAu7QyDZdZbGK2pmvF75C6M3liS0KixupUx+iCEjA=";
=======
    hash = "sha256-+/aeLI1+VE80NdeAqc7ctZsS6i0Ymj/GXssduP8X//c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  modRoot = "./agent";

  excludedPackages = [ "./version/gen" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "The agent that runs on AWS EC2 container instances and starts containers on behalf of Amazon ECS";
    homepage = "https://github.com/aws/amazon-ecs-agent";
    changelog = "https://github.com/aws/amazon-ecs-agent/raw/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
    mainProgram = "agent";
  };
}


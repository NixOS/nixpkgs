{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname   = "amazon-ecs-agent";
  version = "1.63.1";

  goPackagePath = "github.com/aws/${pname}";
  subPackages   = [ "agent" ];

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "aws";
    repo   = pname;
    sha256 = "sha256-wnDwLpCDeIC2D2X/pzC6ZsudJz58xLo1PQB+K6WNxBE=";
  };

  meta = with lib; {
    description = "The agent that runs on AWS EC2 container instances and starts containers on behalf of Amazon ECS";
    homepage    = "https://github.com/aws/amazon-ecs-agent";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ copumpkin ];
    mainProgram = "agent";
  };
}


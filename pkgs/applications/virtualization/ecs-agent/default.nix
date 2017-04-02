{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name    = "${pname}-${version}";
  pname   = "amazon-ecs-agent";
  version = "1.14.0";

  goPackagePath = "github.com/aws/${pname}";
  subPackages   = [ "agent" ];

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "aws";
    repo   = pname;
    sha256 = "12c8l0x8pm883rlbdr1m07r0kjkzggkfz35cjqz8pzyr5ymjdrc3";
  };

  meta = with stdenv.lib; {
    description = "The agent that runs on AWS EC2 container instances and starts containers on behalf of Amazon ECS";
    homepage    = "https://github.com/aws/amazon-ecs-agent";
    license     = licenses.asl20;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ copumpkin ];
  };
}


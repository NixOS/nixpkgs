{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name    = "${pname}-${version}";
  pname   = "amazon-ecs-agent";
  version = "1.18.0";

  goPackagePath = "github.com/aws/${pname}";
  subPackages   = [ "agent" ];

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "aws";
    repo   = pname;
    sha256 = "1l6c2if6wpjmq2hh6k818w38s1rsbwgd6igqy948dwcrb1g1mixr";
  };

  meta = with stdenv.lib; {
    description = "The agent that runs on AWS EC2 container instances and starts containers on behalf of Amazon ECS";
    homepage    = "https://github.com/aws/amazon-ecs-agent";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ copumpkin ];
  };
}


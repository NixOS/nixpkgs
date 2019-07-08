{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name    = "${pname}-${version}";
  pname   = "amazon-ssm-agent";
  version = "2.0.633.0";

  goPackagePath = "github.com/aws/${pname}";
  subPackages   = [ "agent" ];

  src = fetchFromGitHub {
    rev    = "v${version}";
    owner  = "aws";
    repo   = pname;
    sha256 = "10arshfn2k3m3zzgw8b3xc6ywd0ss73746nq5srh2jir7mjzi4xv";
  };

  preBuild = ''
    mv go/src/${goPackagePath}/vendor strange-vendor
    mv strange-vendor/src go/src/${goPackagePath}/vendor
  '';

  meta = with stdenv.lib; {
    description = "Agent to enable remote management of your Amazon EC2 instance configuration";
    homepage    = "https://github.com/aws/amazon-ssm-agent";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ copumpkin ];
  };
}


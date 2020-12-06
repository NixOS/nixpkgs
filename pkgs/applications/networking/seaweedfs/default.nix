{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.13";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "0w41p2fm26ml5dvdg2cnxcw0xzsbjq26chpa3bkn1adpazlpivp4";
  };

  vendorSha256 = "0g344dj325d35i0myrzhg5chspqnly40qp910ml6zrmp7iszc1mw";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}

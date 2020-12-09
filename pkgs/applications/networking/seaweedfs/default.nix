{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "1sfchh5qiylxxmph0hgjfaj80mv5pnrm1s34g5lx0vj64jxr5nzb";
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

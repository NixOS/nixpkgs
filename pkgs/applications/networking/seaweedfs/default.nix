{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.34";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-YQL9xx4dpT1psZqLiF5ojQcEY2EI0szWTS4oOPbG7Co=";
  };

  vendorSha256 = "sha256-8o/Y5SXMgDrid1a5KTQieiVrWce0wcgrhPbSsbravEI=";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}

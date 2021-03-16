{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.31";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-0s/hcRUuskU4TZqk5h4A51mkEJ6uUZS42mKDQvSx3I4=";
  };

  vendorSha256 = "sha256-QpGRQQbNchj0T9USRnALjvOGd2cV+JUgJeRgfjK8n5o=";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}

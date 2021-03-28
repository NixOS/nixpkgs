{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.35";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-J0vwc/sabc6T8+eh94luQdnVltmThapYwLCdyGjCnSc=";
  };

  vendorSha256 = "sha256-u1Aqcm6oJ1y2dVP9BJXV7/1nhNxEOtgZQppoA+cXbD0=";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}

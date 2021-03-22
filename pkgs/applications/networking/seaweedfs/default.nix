{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "seaweedfs";
  version = "2.32";

  src = fetchFromGitHub {
    owner = "chrislusf";
    repo = "seaweedfs";
    rev = version;
    sha256 = "sha256-0VryhH0ELBLVZL2vLuAcjZ0a5otk/etr3riRyc+7YTk=";
  };

  vendorSha256 = "sha256-besXzqlmhFbWfnlacGildBbNATVrtMthf+BA/pL7R5I=";

  subPackages = [ "weed" ];

  meta = with lib; {
    description = "Simple and highly scalable distributed file system";
    homepage = "https://github.com/chrislusf/seaweedfs";
    maintainers = [ maintainers.raboof ];
    license = licenses.asl20;
  };
}

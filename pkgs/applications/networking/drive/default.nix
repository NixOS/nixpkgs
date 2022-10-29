{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "drive";
  version = "unstable-2021-02-08";

  src = fetchFromGitHub {
    owner = "odeke-em";
    repo = "drive";
    rev = "bede608f250a9333d55c43396fc5e72827e806fd";
    sha256 = "sha256-M+XdynUWiICVnHXpmnMvuyoTPFPo0l1EhDkoVlRjpWk=";
  };

  vendorSha256 = "sha256-F/ikdr7UCVlNv2yiEemyB7eIkYi3mX+rJvSfX488RFc=";

  ldflags = [ "-s" "-w" ];

  subPackages = [ "cmd/drive" ];

  meta = with lib; {
    homepage = "https://github.com/odeke-em/drive";
    description = "Google Drive client for the commandline";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}

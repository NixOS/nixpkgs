{
  buildGoModule,
  lib,
  fetchFromGitHub,
  ...
}:
buildGoModule rec {
  pname = "baidupcs-go";
  version = "3.9.5";
  src = fetchFromGitHub {
    owner = "qjfoidnh";
    repo = "BaiduPCS-Go";
    rev = "v${version}";
    fetchSubmodules = false;
    sha256 = "sha256-zNodRQzflOOB3hAeq4KbjRFlHQwknVy+4ucipUcoufY=";
  };

  vendorHash = "sha256-msTlXtidxLTe3xjxTOWCqx/epFT0XPdwGPantDJUGpc=";
  doCheck = false;

  meta = with lib; {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Baidu Netdisk commandline client, mimicking Linux shell file handling commands.";
    homepage = "https://github.com/qjfoidnh/BaiduPCS-Go";
    license = licenses.asl20;
  };
}

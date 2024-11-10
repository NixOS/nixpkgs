{
  buildGo122Module,
  lib,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGo122Module rec {
  pname = "baidupcs-go";
  version = "3.9.5";
  src = fetchFromGitHub {
    owner = "qjfoidnh";
    repo = "BaiduPCS-Go";
    rev = "v${version}";
    hash = "sha256-zNodRQzflOOB3hAeq4KbjRFlHQwknVy+4ucipUcoufY=";
  };

  vendorHash = "sha256-msTlXtidxLTe3xjxTOWCqx/epFT0XPdwGPantDJUGpc=";
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Baidu Netdisk commandline client, mimicking Linux shell file handling commands";
    homepage = "https://github.com/qjfoidnh/BaiduPCS-Go";
    license = lib.licenses.asl20;
    mainProgram = "BaiduPCS-Go";
  };
}

{
  fetchFromGitHub,
  buildGo122Module,
  lib,
  versionCheckHook,
}:
buildGo122Module rec {
  pname = "baidupcs-go";
  version = "3.9.5-unstable-2024-06-23";
  src = fetchFromGitHub {
    owner = "qjfoidnh";
    repo = "BaiduPCS-Go";
    rev = "5612fc337b9556ed330274987a2f876961639cff";
    hash = "sha256-4mCJ5gVHjjvR6HNo47NTJvQEu7cdZZMfO8qQA7Kqzqo=";
  };

  vendorHash = "sha256-msTlXtidxLTe3xjxTOWCqx/epFT0XPdwGPantDJUGpc=";
  doCheck = false;

  ldflags = [
    "-X main.Version=${version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";

  postInstall = ''
    rm -f $out/bin/AndroidNDKBuild
  '';

  postVersionCheck = ''
    rm -f $out/bin/pcs_config.json
  '';

  meta = {
    mainProgram = "BaiduPCS-Go";
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Baidu Netdisk commandline client, mimicking Linux shell file handling commands";
    homepage = "https://github.com/qjfoidnh/BaiduPCS-Go";
    license = lib.licenses.asl20;
  };
}

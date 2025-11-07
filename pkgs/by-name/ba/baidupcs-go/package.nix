{
  fetchFromGitHub,
  buildGoModule,
  lib,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "baidupcs-go";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "qjfoidnh";
    repo = "BaiduPCS-Go";
    rev = "v${version}";
    hash = "sha256-synfJtYZmIiK2SoTG0rt+qZ0ixXIXDXnrNL2s5eDtQY=";
  };

  vendorHash = "sha256-oOZeBCHpAasi9K77xA+8HxZErGWKwb4OaWzWhHagtQE=";

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
    ln -s $out/bin/BaiduPCS-Go $out/bin/baidupcs-go || true
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

{
  fetchFromGitHub,
  buildGoModule,
  lib,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "baidupcs-go";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "qjfoidnh";
    repo = "BaiduPCS-Go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-o0Oh6zLJT25+smEgWy7E8fTigJ2FLpBXoaZSYCRFvic=";
  };

  vendorHash = "sha256-3kvB5QxtWuElhDIFFr3Awf5myf6l2Hx0M2k53ltQYeQ=";

  doCheck = false;

  ldflags = [
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

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
})

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "aliyun-cli";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "aliyun";
    repo = "aliyun-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j7WiJjsQQs2x20jv4Ec3Rbi2fm5+jSi9F7BZACKjUjs=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-DfQQYSTX/aH2z7S/dO7PVCrrU5mjHX/wwtFx83xwLjw=";

  subPackages = [ "main" ];

  # Build like upstream's release artifacts: bake the OpenAPI metadata into the
  # binary. The default "dev" build resolves the metadata from
  # $ALIYUN_CLI_META_DIR or ./aliyun-openapi-meta at runtime and panics in
  # meta.LoadRepository() when neither is present.
  tags = [ "aliyun_cli_packed_meta" ];

  preBuild = ''
    GOOS= GOARCH= go generate ./bundledmeta
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/aliyun/aliyun-cli/v3/cli.Version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  versionCheckKeepEnvironment = [ "HOME" ];

  postInstall = ''
    mv $out/bin/main $out/bin/aliyun
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to manage and use Alibaba Cloud resources through a command line interface";
    homepage = "https://github.com/aliyun/aliyun-cli";
    changelog = "https://github.com/aliyun/aliyun-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ornxka
      ryan4yin
    ];
    mainProgram = "aliyun";
  };
})

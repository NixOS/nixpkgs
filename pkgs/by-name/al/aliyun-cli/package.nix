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
  version = "3.5.2";

  src = fetchFromGitHub {
    owner = "aliyun";
    repo = "aliyun-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZvHldYiUNNNIoEdoJvqUSs2ZLQAIm5Mt9/EMxbMM/2A=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-xxbA3fpOetotYcmc3ntRqYkCyHRTzqupCoPm/8FYW1Y=";

  subPackages = [ "main" ];

  # Build like upstream's release artifacts: bake the OpenAPI metadata into the binary.
  tags = [ "aliyun_cli_packed_meta" ];

  # Don't run go generate in the module fetching (preBuild runs before vendor/ exists).
  overrideModAttrs = _: {
    preBuild = null;
  };

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

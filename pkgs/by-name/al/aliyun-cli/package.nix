{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "aliyun-cli";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "aliyun";
    repo = "aliyun-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v44QWIpFTfUD7gOaQGwJ12MvtO4rMS69rCZr4Hv/e3k=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-smlPjS2kda0ij+3Jch/FKRHm820Zux6vWXooqhm6fCA=";

  subPackages = [ "main" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/aliyun/aliyun-cli/v3/cli.Version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

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

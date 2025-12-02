{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "aliyun-cli";
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "aliyun";
    repo = "aliyun-cli";
    tag = "v${version}";
    hash = "sha256-H0+XAOVXg9UAvWQC1hVUQs5AbqCVpw9NKtRKhm7m9Lw=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-lmlCPBEqopmoNjkihVOh8zKSKsS4HmaDQ+QAEJ/pEvA=";

  subPackages = [ "main" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/aliyun/aliyun-cli/v3/cli.Version=${version}"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  postInstall = ''
    mv $out/bin/main $out/bin/aliyun
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to manage and use Alibaba Cloud resources through a command line interface";
    homepage = "https://github.com/aliyun/aliyun-cli";
    changelog = "https://github.com/aliyun/aliyun-cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ornxka
      ryan4yin
    ];
    mainProgram = "aliyun";
  };
}

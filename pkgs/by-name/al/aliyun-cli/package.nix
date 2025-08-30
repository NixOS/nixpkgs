{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "aliyun-cli";
  version = "3.0.299";

  src = fetchFromGitHub {
    owner = "aliyun";
    repo = "aliyun-cli";
    tag = "v${version}";
    hash = "sha256-9312AWM6yzF8asL7+ziU3C4VtsFV6vrPZS4so09P4vw=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-7OI9YDehiKP5+VvCc0jUtCfyCPP5puWjyWXFE7Tjv5Q=";

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

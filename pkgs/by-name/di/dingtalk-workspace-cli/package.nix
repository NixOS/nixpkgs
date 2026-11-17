{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "dingtalk-workspace-cli";
  version = "1.0.65";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DingTalk-Real-AI";
    repo = "dingtalk-workspace-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QGnZp8dqI1K/SgwmZBUr1Um3w70iScsjoNjd5+4viu0=";
  };

  proxyVendor = true;
  vendorHash = "sha256-1zE2scTJ11veAaH/O8ZF0ETA2UE4lhegEkSt3p9ix+8=";

  subPackages = [ "cmd" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-X github.com/DingTalk-Real-AI/dingtalk-workspace-cli/internal/app.version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv "$out/bin/cmd" "$out/bin/dws"

    installShellCompletion --cmd dws \
      --bash <("$out/bin/dws" completion bash) \
      --zsh <("$out/bin/dws" completion zsh) \
      --fish <("$out/bin/dws" completion fish)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "DingTalk Workspace command-line client";
    homepage = "https://github.com/DingTalk-Real-AI/dingtalk-workspace-cli";
    # Although upstream declares Apache-2.0, the binary embeds a provider-licensed
    # runtime payload and statically links the prebuilt libsafechat.a.
    license = lib.licenses.unfreeRedistributable;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "dws";
  };
})

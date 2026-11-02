{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "dingtalk-workspace-cli";
  version = "1.0.66";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DingTalk-Real-AI";
    repo = "dingtalk-workspace-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PsiDPeU9yBAyJVPrjWwBuMhdD7jju/P/b5oYPTkzTJA=";
  };

  proxyVendor = true;
  vendorHash = "sha256-RYQ78aqd64YNDGBkYXpSJZ1HJZeX5MzU7KytUnRpJmo=";

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

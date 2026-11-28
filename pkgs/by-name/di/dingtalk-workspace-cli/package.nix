{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "dingtalk-workspace-cli";
  version = "1.0.69";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DingTalk-Real-AI";
    repo = "dingtalk-workspace-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XMGTibJwwAbKYfLADaQIq33gdbLnSIJWX3vJftf0fsM=";
  };

  proxyVendor = true;
  vendorHash = "sha256-RYQ78aqd64YNDGBkYXpSJZ1HJZeX5MzU7KytUnRpJmo=";

  patches = [
    # Fix shell completions: let cobra's hidden `__complete` commands through pre-parse.
    # See https://github.com/DingTalk-Real-AI/dingtalk-workspace-cli/pull/1533.
    (fetchpatch {
      name = "fix-shell-completion-reserved-commands.patch";
      url = "https://github.com/DingTalk-Real-AI/dingtalk-workspace-cli/commit/d2f07d8611a7a61ce2eac34aa9983b8a2b1eb0f0.patch";
      hash = "sha256-KUpyCmrvspD3S2sTELpmO/hd9UqJL0qmBt68YicZOUA=";
    })
  ];

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

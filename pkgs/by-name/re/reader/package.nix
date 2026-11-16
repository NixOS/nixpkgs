{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "reader";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "reader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U9EXo3mAkeYVMOyEwIPWODqeg36lPj2ARNqW1yKayNI=";
  };

  vendorHash = "sha256-xs8zNXTYhbj6Ilhmf1IRyQUwV95Em7qwV/V3+IXRxFI=";

  nativeBuildInputs = [ installShellFiles ];

  # tests start httptest servers on localhost
  __darwinAllowLocalNetworking = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd reader \
      --bash <($out/bin/reader completion bash) \
      --fish <($out/bin/reader completion fish) \
      --zsh <($out/bin/reader completion zsh)
  '';

  meta = {
    description = "Lightweight tool offering better readability of web pages on the CLI";
    homepage = "https://github.com/mrusme/reader";
    changelog = "https://github.com/mrusme/reader/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "reader";
  };
})

{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "desync";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "folbricht";
    repo = "desync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WPhxXHB4d+yGX/94GwEJa3HEYZhIq7ncDEMd+NeY7bQ=";
  };

  vendorHash = "sha256-08LGC+N0NjUAjo9b5JhKNr46CuIXMz/erw2RPRU17xo=";

  ldflags = [ "-X main.version=${finalAttrs.src.tag}" ];

  nativeBuildInputs = [ installShellFiles ];

  # required for TestHTTPHandlerReadWrite and other tests
  __darwinAllowLocalNetworking = true;

  # sendfile(2) in XNU kernel does not set remote address when checking syscall against sandbox rules
  # https://github.com/apple-oss-distributions/xnu/blob/f6217f891ac0bb64f3d375211650a4c1ff8ca1ea/bsd/kern/uipc_syscalls.c#L3790-L3791
  sandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
    (allow network-outbound (require-all (local ip) (require-not (remote ip))))
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd desync \
      --bash <($out/bin/desync completion bash) \
      --fish <($out/bin/desync completion fish) \
      --zsh <($out/bin/desync completion zsh)

    mkdir -p $out/share/man/man1
    $out/bin/desync manpage --section 1 $out/share/man/man1
  '';

  meta = {
    description = "Content-addressed binary distribution system";
    mainProgram = "desync";
    longDescription = "An alternate implementation of the casync protocol and storage mechanism with a focus on production-readiness";
    homepage = "https://github.com/folbricht/desync";
    changelog = "https://github.com/folbricht/desync/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ matshch ];
  };
})

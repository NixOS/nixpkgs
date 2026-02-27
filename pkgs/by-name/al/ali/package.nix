{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "ali";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "nakabonne";
    repo = "ali";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iwuvWqDaaf/U8f4KDeq1gs+FlDoC11uDs+l2Z7Npd6M=";
  };

  vendorHash = "sha256-pRxkRY0MkQGnNhA/3CtT0ohKAPNx8QeyuD6bcacYHGI=";

  meta = {
    description = "Generate HTTP load and plot the results in real-time";
    homepage = "https://github.com/nakabonne/ali";
    changelog = "https://github.com/nakabonne/ali/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ farcaller ];
    mainProgram = "ali";
    # Broken on darwin for Go toolchain > 1.22, with error:
    # 'link: golang.org/x/net/internal/socket: invalid reference to syscall.recvmsg'
    broken = stdenv.hostPlatform.isDarwin;
  };
})

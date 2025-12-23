{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "ali";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "nakabonne";
    repo = "ali";
    tag = "v${version}";
    hash = "sha256-/pdHlI20IzSTX2pnsbxPiJiWmOCbp13eJWLi0Tcsueg=";
  };

  vendorHash = "sha256-YWx9K04kTMaI0FXebwRQVCt0nxIwZ6xlbtI2lk3qp0M=";

  meta = {
    description = "Generate HTTP load and plot the results in real-time";
    homepage = "https://github.com/nakabonne/ali";
    changelog = "https://github.com/nakabonne/ali/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ farcaller ];
    mainProgram = "ali";
    # Broken on darwin for Go toolchain > 1.22, with error:
    # 'link: golang.org/x/net/internal/socket: invalid reference to syscall.recvmsg'
    broken = stdenv.hostPlatform.isDarwin;
  };
}

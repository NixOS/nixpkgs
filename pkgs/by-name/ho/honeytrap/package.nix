{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:
buildGoModule {
  pname = "honeytrap";
  version = "0-unstable-2021-12-20";

  src = fetchFromGitHub {
    owner = "honeytrap";
    repo = "honeytrap";
    rev = "05965fc67deab17b48e43873abc5f509067ef098";
    hash = "sha256-KSVqjHlXl85JaqKiW5R86HCMdtFBwTMJkxFoySOcahs=";
  };

  vendorHash = "sha256-W8w66weYzCpZ+hmFyK2F6wdFz6aAZ9UxMhccNy1X1R8=";

  # Otherwise, will try to install a "scripts" binary; it's only used in
  # dockerize.sh, which we don't care about.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Advanced Honeypot framework";
    mainProgram = "honeytrap";
    homepage = "https://github.com/honeytrap/honeytrap";
    license = licenses.asl20;
    maintainers = [ ];
    # Broken on darwin for Go toolchain > 1.22, with error:
    # 'link: golang.org/x/net/internal/socket: invalid reference to syscall.recvmsg'
    broken = stdenv.hostPlatform.isDarwin;
  };
}

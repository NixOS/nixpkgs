{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libpcap,
  libnfnetlink,
  libnetfilter_queue,
  libusb1,
}:

buildGoModule (finalAttrs: {
  pname = "bettercap";
  version = "2.41.5";

  src = fetchFromGitHub {
    owner = "bettercap";
    repo = "bettercap";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mw2Fe/7kSowozUpmXC5tMHZ02bF5+UHmy+lmkJ6SeLM=";
  };

  vendorHash = "sha256-ssNGy40KMJ9P33uEGyYOer92QRS2T6DQlKaf/3XMFwQ=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libpcap
    libusb1
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libnfnetlink
    libnetfilter_queue
  ];

  meta = {
    description = "Man in the middle tool";
    longDescription = ''
      BetterCAP is a powerful, flexible and portable tool created to perform various
      types of MITM attacks against a network, manipulate HTTP, HTTPS and TCP traffic
      in realtime, sniff for credentials and much more.
    '';
    homepage = "https://www.bettercap.org/";
    license = with lib.licenses; [ gpl3Only ];
    mainProgram = "bettercap";
    # Broken on darwin for Go toolchain > 1.22, with error:
    # 'link: golang.org/x/net/internal/socket: invalid reference to syscall.recvmsg'
    broken = stdenv.hostPlatform.isDarwin;
  };
})

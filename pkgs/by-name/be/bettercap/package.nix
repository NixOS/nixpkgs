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

buildGoModule rec {
  pname = "bettercap";
  version = "2.41.4";

  src = fetchFromGitHub {
    owner = "bettercap";
    repo = "bettercap";
    rev = "v${version}";
    sha256 = "sha256-y23gNqS5f/MP+wyRMxe40I+9RuZGyZEok17LIc9Z8O4=";
  };

  vendorHash = "sha256-1kgjMPsj8z2Cl0YWe/1zY0Zuiza0X+ZAIgsMqPhCrMw=";

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

  meta = with lib; {
    description = "Man in the middle tool";
    longDescription = ''
      BetterCAP is a powerful, flexible and portable tool created to perform various
      types of MITM attacks against a network, manipulate HTTP, HTTPS and TCP traffic
      in realtime, sniff for credentials and much more.
    '';
    homepage = "https://www.bettercap.org/";
    license = with licenses; [ gpl3Only ];
    mainProgram = "bettercap";
    # Broken on darwin for Go toolchain > 1.22, with error:
    # 'link: golang.org/x/net/internal/socket: invalid reference to syscall.recvmsg'
    broken = stdenv.hostPlatform.isDarwin;
  };
}

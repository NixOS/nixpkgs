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
<<<<<<< HEAD
  version = "2.41.5";
=======
  version = "2.41.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "bettercap";
    repo = "bettercap";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-mw2Fe/7kSowozUpmXC5tMHZ02bF5+UHmy+lmkJ6SeLM=";
  };

  vendorHash = "sha256-ssNGy40KMJ9P33uEGyYOer92QRS2T6DQlKaf/3XMFwQ=";
=======
    sha256 = "sha256-y23gNqS5f/MP+wyRMxe40I+9RuZGyZEok17LIc9Z8O4=";
  };

  vendorHash = "sha256-1kgjMPsj8z2Cl0YWe/1zY0Zuiza0X+ZAIgsMqPhCrMw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Man in the middle tool";
    longDescription = ''
      BetterCAP is a powerful, flexible and portable tool created to perform various
      types of MITM attacks against a network, manipulate HTTP, HTTPS and TCP traffic
      in realtime, sniff for credentials and much more.
    '';
    homepage = "https://www.bettercap.org/";
<<<<<<< HEAD
    license = with lib.licenses; [ gpl3Only ];
=======
    license = with licenses; [ gpl3Only ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "bettercap";
    # Broken on darwin for Go toolchain > 1.22, with error:
    # 'link: golang.org/x/net/internal/socket: invalid reference to syscall.recvmsg'
    broken = stdenv.hostPlatform.isDarwin;
  };
}

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
  version = "2.42.0";

  src = fetchFromGitHub {
    owner = "bettercap";
    repo = "bettercap";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-oNPa+QThiQ5vJwUa9pCQUYS/uYAwRzEmIgtfOTWToPs=";
  };

  vendorHash = "sha256-LVl105ItFXVLXdGLGtO3LaYl9mrMbIHd515Huv7gGHs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libpcap
    libusb1
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libnfnetlink
    libnetfilter_queue
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Man in the middle tool";
    longDescription = ''
      BetterCAP is a powerful, flexible and portable tool created to perform various
      types of MITM attacks against a network, manipulate HTTP, HTTPS and TCP traffic
      in realtime, sniff for credentials and much more.
    '';
    homepage = "https://www.bettercap.org/";
    license = lib.licenses.gpl3Only;
    mainProgram = "bettercap";
  };
})

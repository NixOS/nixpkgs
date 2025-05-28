{
  lib,
  stdenv,
  buildGo122Module,
  fetchFromGitHub,
  pkg-config,
  libpcap,
  libnfnetlink,
  libnetfilter_queue,
  libusb1,
}:

buildGoModule rec {
  pname = "bettercap";
  version = "2.41.0";

  src = fetchFromGitHub {
    owner = "bettercap";
    repo = "bettercap";
    rev = "v${version}";
    sha256 = "sha256-qQNsdKUiTSXkvfIguR1Rjs3A1WW4G1ernqRWTKBjIVI=";
  };

  vendorHash = "sha256-OxcBk22TvlcnHqJ0VzuewZtWLm/DPo6Cdq7RKabOg8w=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
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
    maintainers = with maintainers; [ y0no ];
    mainProgram = "bettercap";
  };
}

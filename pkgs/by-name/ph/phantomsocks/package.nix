{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  libpcap,
  # Can't be build with both pcap and rawsocket tags
  withPcap ? (!stdenv.hostPlatform.isLinux && !withRawsocket),
  withRawsocket ? (stdenv.hostPlatform.isLinux && !withPcap),
}:

buildGoModule {
  pname = "phantomsocks";
  version = "0-unstable-2025-08-07";

  src = fetchFromGitHub {
    owner = "macronut";
    repo = "phantomsocks";
    rev = "c52f1bde25ed5df07eb4cd010a3d508c5cf023e0";
    hash = "sha256-V9XBCHih409IqKx3TM37fvxYzP0bv46M0DgKgj64RFg=";
  };

  vendorHash = "sha256-0MJlz7HAhRThn8O42yhvU3p5HgTG8AkPM0ksSjWYAC4=";

  ldflags = [
    "-s"
    "-w"
  ];
  buildInputs = lib.optional withPcap libpcap;
  tags = lib.optional withPcap "pcap" ++ lib.optional withRawsocket "rawsocket";

  meta = with lib; {
    homepage = "https://github.com/macronut/phantomsocks";
    description = "Cross-platform proxy client/server for Linux/Windows/macOS";
    longDescription = ''
      A cross-platform proxy tool that could be used to modify TCP packets
      to implement TCB desync to bypass detection and censoring.
    '';
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ oluceps ];
    mainProgram = "phantomsocks";
  };
}

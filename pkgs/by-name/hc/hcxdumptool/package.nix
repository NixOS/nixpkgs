{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hcxdumptool";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    tag = finalAttrs.version;
    hash = "sha256-7z0VCR9ouISFcsIvS8t1m93G6grUNDOansGGmnIq6bI=";
  };

  buildInputs = [
    openssl
    libpcap
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/ZerBea/hcxdumptool";
    description = "Small tool to capture packets from wlan devices";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ danielfullmer ];
    mainProgram = "hcxdumptool";
  };
})

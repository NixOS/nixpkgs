{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hcxdumptool";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    tag = finalAttrs.version;
    hash = "sha256-emSIUSE8r0PX1qhkuIQcyh9+rBB+jBA6pmt+n4WugWk=";
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

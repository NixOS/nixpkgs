{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hcxdumptool";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    tag = finalAttrs.version;
    hash = "sha256-ABbhhojg4PJlK7xwPW8m7ExQym6hrZmKBsqxnGrjA8A=";
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

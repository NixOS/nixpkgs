{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hcxdumptool";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    tag = finalAttrs.version;
    hash = "sha256-54gKvOcmNxMND1iXJCgwtwT+PYntukVKtdT4dLwOOpI=";
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

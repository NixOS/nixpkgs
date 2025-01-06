{
  stdenv,
  lib,
  fetchFromGitHub,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "hcxdumptool";
  version = "6.3.2";

  src = fetchFromGitHub {
    owner = "ZerBea";
    repo = "hcxdumptool";
    rev = version;
    sha256 = "sha256-InMyDUEH135Y1RYJ3z1+RQxPMi7+QMf670S/S2ZL9vg=";
  };

  buildInputs = [ openssl ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/ZerBea/hcxdumptool";
    description = "Small tool to capture packets from wlan devices";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ danielfullmer ];
    mainProgram = "hcxdumptool";
  };
}

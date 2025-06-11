{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  fetchpatch,
  openssl,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "ike-scan";
  version = "1.9.5-unstable-2024-09-15";

  src = fetchFromGitHub {
    owner = "royhills";
    repo = "ike-scan";
    rev = "c74c01fd22d9a3aae3d8ba9a0bd2eb1a2146ac6f";
    hash = "sha256-+eicvirqzZrAJiaGaVjqZlSpU2+jTG/MRPv50P+1Tpc=";
  };

  patches = [
    # Using the same patches as for the Fedora RPM
    (fetchpatch {
      # Memory leaks, https://github.com/royhills/ike-scan/pull/15
      url = "https://github.com/royhills/ike-scan/pull/15/commits/d864811de08dcddd65ac9b8d0f2acf5d7ddb9dea.patch";
      hash = "sha256-VVJZSTZfDV0qHuxdNoZV1NXJYCEMtB0bO1oi2hLCeXE=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    openssl
  ];

  configureFlags = [ "--with-openssl=${openssl.dev}" ];

  meta = with lib; {
    description = "Tool to discover, fingerprint and test IPsec VPN servers";
    longDescription = ''
      ike-scan is a command-line tool that uses the IKE protocol to discover,
      fingerprint and test IPsec VPN servers.
    '';
    homepage = "https://github.com/royhills/ike-scan";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fab ];
  };
}

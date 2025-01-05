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
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "royhills";
    repo = pname;
    rev = version;
    sha256 = "sha256-mbfg8p3y4aKoXpmLuF9GXAMPEqV5CsvetwGCRDJ9UNY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    openssl
  ];

  configureFlags = [ "--with-openssl=${openssl.dev}" ];

  patches = [
    # Using the same patches as for the Fedora RPM
    (fetchpatch {
      # Memory leaks, https://github.com/royhills/ike-scan/pull/15
      url = "https://github.com/royhills/ike-scan/pull/15/commits/d864811de08dcddd65ac9b8d0f2acf5d7ddb9dea.patch";
      sha256 = "0wbrq89dl8js7cdivd0c45hckmflan33cpgc3qm5s3az6r4mjljm";
    })
  ];

  meta = with lib; {
    description = "Tool to discover, fingerprint and test IPsec VPN servers";
    longDescription = ''
      ike-scan is a command-line tool that uses the IKE protocol to discover,
      fingerprint and test IPsec VPN servers.
    '';
    homepage = "https://github.com/royhills/ike-scan";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ fab ];
  };
}

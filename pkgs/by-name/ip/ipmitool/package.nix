{
  stdenv,
  lib,
  fetchFromGitea,
  autoreconfHook,
  pkg-config,
  openssl,
  readline,
  fetchurl,
}:

let
  iana-enterprise-numbers = fetchurl {
    url = "https://web.archive.org/web/20250113140800id_/https://www.iana.org/assignments/enterprise-numbers.txt";
    hash = "sha256-aRgBEfZYwoL6YnU3aD0WYeMnJD5ZCj34S/9aQyzBIO4=";
  };
in
stdenv.mkDerivation {
  pname = "ipmitool";
  version = "1.8.19-unstable-2025-02-18";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "IPMITool";
    repo = "ipmitool";
    rev = "3c91e6d91ec6090fe548c55ef301c33ff20c8ed8";
    hash = "sha256-7R3jmPPd8+yKs7Q1vlU/ZaZusZVB0s+xc1HGeLyLdk0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    openssl
    readline
  ];

  configureFlags = [ "--disable-registry-download" ];

  postInstall = ''
    # Install to path reported in configure as "Set IANA PEN dictionary search path to ..."
    install -Dm444 ${iana-enterprise-numbers} $out/share/misc/enterprise-numbers
  '';

  meta = {
    description = "Command-line interface to IPMI-enabled devices";
    mainProgram = "ipmitool";
    license = lib.licenses.bsd3;
    homepage = "https://codeberg.org/IPMITool/ipmitool";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fpletz ];
  };
}

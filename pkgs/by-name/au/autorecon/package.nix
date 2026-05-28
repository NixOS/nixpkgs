{
  lib,
  python3Packages,
  fetchFromGitHub,
  dnsrecon,
  enum4linux-ng,
  whatweb,
  nikto,
  nbtscan,
  onesixtyone,
  seclists,
  curl,
  smbmap,
  sslscan,
  redis,
  smbclient-ng,
  net-snmp,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "autorecon";
  version = "0-unstable-2025-11-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AutoRecon";
    repo = "AutoRecon";
    rev = "e7e98f60bdc5fb1695159c1bbcdfdf2746d30fa6";
    hash = "sha256-xSRfsfLRYt7jS5Jpp6fz5/Kj2DiNI3hgUbUI9w3AHkw=";
  };

  postPatch = ''
    substituteInPlace autorecon/global.toml autorecon/config.toml \
      --replace-fail "/usr/share/seclists" "${seclists}/share/wordlists/seclists"

    substituteInPlace autorecon/default-plugins/*.py \
      --replace-quiet "/usr/share/seclists" "${seclists}/share/wordlists/seclists"
  '';

  pythonRelaxDeps = [
    "impacket"
    "psutil"
  ];

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    unidecode
    colorama
    impacket
    platformdirs
    psutil
    requests
    toml
  ];

  propagatedBuildInputs = [
    net-snmp
    smbclient-ng
    redis
    sslscan
    smbmap
    curl
    seclists
    onesixtyone
    nbtscan
    nikto
    whatweb
    enum4linux-ng
    dnsrecon
    # the following optional deps are not packaged in nix
    # oscanner
    # oracle-scanner
    # svwar
    # tnscmd10g
  ];

  __structuredAttrs = true;

  pythonImportsCheck = [ "autorecon" ];

  meta = {
    description = "Multi-threaded network reconnaissance tool which performs automated enumeration of services";
    license = lib.licenses.gpl3Only;
    homepage = "https://github.com/AutoRecon/AutoRecon";
    maintainers = with lib.maintainers; [
      Darks1de42
    ];
    mainProgram = "autorecon";
  };
})

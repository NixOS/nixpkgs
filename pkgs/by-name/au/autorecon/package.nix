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
  pkgs,
  seclists,
  curl,
  smbmap,
  sslscan,
}:
# the following optional deps are not packaged in nix
# oscanner
# oracle-scanner
# redis-tools
#smbclient smbclient-ng?
#snmpwalk
#svwar
#tnscmd10g

python3Packages.buildPythonPackage (finalAttrs: {
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
    substituteInPlace autorecon/global.toml \
      --replace-fail "/usr/share/seclists" "${seclists}/share/wordlists/seclists"

    substituteInPlace autorecon/config.toml \
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

  __structuredAttrs = true; # RFC 140

  preFixup = ''
    wrapProgram $out/bin/autorecon \
      --suffix PATH : ${
        lib.makeBinPath [
          dnsrecon
          enum4linux-ng
          whatweb
          onesixtyone
          nbtscan
          nikto
          curl
          smbmap
          sslscan
        ]
      }
  '';

  pythonImportsCheck = [ "autorecon" ];

  meta = {
    description = "AutoRecon is a multi-threaded network reconnaissance tool which performs automated enumeration of services. ";
    license = lib.licenses.gpl3;
    homepage = "https://github.com/AutoRecon/AutoRecon";
    maintainers = with lib.maintainers; [
      Darks1de42
    ];
    mainProgram = "autorecon";
  };
})

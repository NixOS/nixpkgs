{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, python3
, seclists
, curl
, dnsrecon
, enum4linux
, feroxbuster
, gobuster
, impacket-scripts
, nbtscan
, nikto
, nmap
, onesixtyone
, oscanner
, valkey
, samba
, smbmap
, net-snmp
, sslscan
, tnscmd10g
, whatweb
, dirsearch
, ffuf
, dirb
, dig
, rsync
, nfs-utils
, thc-hydra
}:

python3.pkgs.buildPythonApplication rec {
  pname = "autorecon";
  version = "0-unstable-2024-06-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tib3rius";
    repo = "AutoRecon";
    rev = "19cc46b4c8d526a345412ef064e19f6e67965e40";
    hash = "sha256-7Yi0WOfv/I6aFFZKrQjK8cyZNdpyx/ifcGiYVWh1WeU=";
  };

  patches = [
    (fetchurl {
      name = "fix-invalid-escape-sequence-errors.patch";
      url = "https://gitlab.com/kalilinux/packages/autorecon/-/raw/00b26cb4c663dbec7668bd90677f48ad194ab28f/debian/patches/fix-invalid-escape-sequence-errors.patch";
      hash = "sha256-Kp943Ks0/jXiXvjPZSzsibS2dZgUOeNHLmOZn54dBEo=";
    })
    # Don't copy read-only file permissions when creating default config/data
    ./dont-copy-perms.patch
  ];

  postPatch = ''
    # Replace hardcoded seclists path
    find . -type f -exec sed -i 's|/usr/share/seclists/|${seclists}/share/wordlists/seclists/|g' {} +

    # wkhtmltopdf marked as insecure in nixpkgs
    rm autorecon/default-plugins/wkhtmltoimage.py
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    colorama
    impacket
    psutil
    requests
    toml
    unidecode
  ];

  pythonRelaxDeps = true;

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath ([
      # Runtime dependencies listed in README.md
      curl
      dnsrecon
      enum4linux
      feroxbuster
      gobuster
      impacket-scripts
      nbtscan
      nikto
      nmap
      onesixtyone
      oscanner
      valkey
      samba
      smbmap
      net-snmp
      sslscan
      # sipvicious is always a manual command
      tnscmd10g
      whatweb
      # wkhtmltopdf marked as insecure

      # Runtime dependencies not listed in README.md
      dirsearch
      ffuf
      dirb
      dig
      rsync
      thc-hydra
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [ nfs-utils ])}"
  ];

  meta = {
    description = "Network reconnaissance tool which performs automated enumeration of services";
    homepage = "https://github.com/Tib3rius/AutoRecon";
    license = lib.licenses.gpl3Only;
    mainProgram = "autorecon";
    maintainers = with lib.maintainers; [ emilytrau ];
  };
}

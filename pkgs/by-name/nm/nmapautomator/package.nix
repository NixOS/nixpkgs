{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  dirb,
  metasploit,
  nix-update-script,
  withFullDeps ? false,

  # required dependencies
  nmap,
  coreutils,
  gawk,
  gnugrep,
  gnused,
  findutils,

  # optional dependencies
  smtp-user-enum,
  dnsrecon,
  bind,
  sslscan,
  nikto,
  ffuf,
  joomscan,
  smbmap,
  enum4linux,
  wpscan,
  samba,
  openldap,
  net-snmp,
  snmpcheck,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nmapautomator";
  version = "0-unstable-2021-04-10";

  src = fetchFromGitHub {
    owner = "21y4d";
    repo = "nmapAutomator";
    rev = "c5e15de8429c78aa5923010145dfac0996aba9e1";
    hash = "sha256-HwBvhFvGVY5q0C62XjNalQUaX7y24B1Vt8UqAIHp8/g=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  runtimeDeps = [
    nmap
    coreutils
    gawk
    gnugrep
    gnused
    findutils
  ]
  ++ lib.optionals withFullDeps [
    smtp-user-enum
    dnsrecon
    bind.dnsutils
    bind.host
    sslscan
    nikto
    ffuf
    joomscan
    smbmap
    enum4linux
    wpscan
    samba
    openldap
    net-snmp
    snmpcheck
  ];
  # TODO: Package and add odat and droopescan

  postPatch = ''
    substituteInPlace nmapAutomator.sh \
      --replace-fail '/usr/share/nmap/' '${nmap}/share/nmap/' \
      --replace-fail '/usr/share/wordlists/dirb/' '${dirb}/share/dirb/wordlists/' \
      --replace-fail '/usr/share/wordlists/metasploit/' '${metasploit.src}/data/wordlists/'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 555 nmapAutomator.sh $out/bin/nmapAutomator
    wrapProgram $out/bin/nmapAutomator \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=master" ]; };

  meta = {
    description = "Nmap script to automate the process of enumeration & recon";
    homepage = "https://github.com/21y4d/nmapAutomator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ letgamer ];
    mainProgram = "nmapAutomator";
  };
})

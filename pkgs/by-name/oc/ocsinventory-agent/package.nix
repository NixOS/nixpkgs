{ lib
, stdenv
, perlPackages
, fetchFromGitHub
, makeWrapper
, shortenPerlShebang
, coreutils
, dmidecode
, findutils
, inetutils
, ipmitool
, iproute2
, lvm2
, nmap
, pciutils
, usbutils
, util-linux
, nixosTests
, testers
, ocsinventory-agent
, nix-update-script
}:

perlPackages.buildPerlPackage rec {
  version = "2.10.1";
  pname = "ocsinventory-agent";

  src = fetchFromGitHub {
    owner = "OCSInventory-NG";
    repo = "UnixAgent";
    rev = "refs/tags/v${version}-MAC";
    hash = "sha256-aFzBrUsVttUhpYGEYd/yYuXmE90PGCiBmBsVjtHcHLg=";
  };

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.isDarwin shortenPerlShebang;

  buildInputs = with perlPackages; [
    perl
    DataUUID
    IOCompress
    IOSocketSSL
    LWP
    LWPProtocolHttps
    NetIP
    NetNetmask
    NetSNMP
    ParseEDID
    ProcDaemon
    ProcPIDFile
    XMLSimple
  ] ++ lib.optionals stdenv.isLinux (with perlPackages; [
    NetCUPS # cups-filters is broken on darwin
  ]) ++ lib.optionals stdenv.isDarwin (with perlPackages; [
    MacSysProfile
  ]);

  postInstall = let
    runtimeDependencies = [
      coreutils # uname, cut, df, stat, uptime
      findutils # find
      inetutils # ifconfig
      ipmitool # ipmitool
      nmap # nmap
      pciutils # lspci
    ] ++ lib.optionals stdenv.isLinux [
      dmidecode # dmidecode
      iproute2 # ip
      lvm2 # pvs
      usbutils # lsusb
      util-linux # last, lsblk, mount
    ];
  in lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/ocsinventory-agent
  '' + ''
    wrapProgram $out/bin/ocsinventory-agent --prefix PATH : ${lib.makeBinPath runtimeDependencies}
  '';

  passthru = {
    tests = {
      inherit (nixosTests) ocsinventory-agent;
      version = testers.testVersion {
        package = ocsinventory-agent;
        command = "ocsinventory-agent --version";
        # upstream has not updated version in lib/Ocsinventory/Agent/Config.pm
        version = "2.10.0";
      };
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "OCS Inventory unified agent for Unix operating systems";
    longDescription = ''
      Open Computers and Software Inventory (OCS) is an application designed
      to help a network or system administrator to keep track of the hardware and
      software configurations of computers that are installed on the network.
    '';
    homepage = "https://ocsinventory-ng.org";
    changelog = "https://github.com/OCSInventory-NG/UnixAgent/releases/tag/v${version}";
    downloadPage = "https://github.com/OCSInventory-NG/UnixAgent/releases";
    license = licenses.gpl2Only;
    mainProgram = "ocsinventory-agent";
    maintainers = with maintainers; [ totoroot anthonyroussel ];
    platforms = platforms.unix;
  };
}

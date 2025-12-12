{
  lib,
  stdenv,
  perlPackages,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  shortenPerlShebang,
  coreutils,
  dmidecode,
  findutils,
  inetutils,
  ipmitool,
  iproute2,
  lvm2,
  nmap,
  pciutils,
  usbutils,
  util-linux,
  nixosTests,
  testers,
  ocsinventory-agent,
  nix-update-script,
}:

perlPackages.buildPerlPackage rec {
  pname = "ocsinventory-agent";
  version = "2.10.4";

  src = fetchFromGitHub {
    owner = "OCSInventory-NG";
    repo = "UnixAgent";
    tag = "v${version}";
    hash = "sha256-MKUYf3k47lHc9dTGo1wYd7r4GrX98dU+04mF0Jm5e9U=";
  };

  patches = [
    # Fix Getopt-Long warnings
    # See https://github.com/OCSInventory-NG/UnixAgent/pull/490
    (fetchpatch {
      url = "https://github.com/OCSInventory-NG/UnixAgent/commit/c4899cef6b797df471ddf41c427970de47302f80.patch";
      hash = "sha256-HxcWb9jmHiL0r6VWlsvmKUuybnM9W5471FLBBe3Zrfs=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.hostPlatform.isDarwin shortenPerlShebang;

  buildInputs =
    with perlPackages;
    [
      perl
      DataUUID
      GetoptLong
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
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux (
      with perlPackages;
      [
        NetCUPS # cups-filters is broken on darwin
      ]
    )
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with perlPackages;
      [
        MacSysProfile
      ]
    );

  postInstall =
    let
      runtimeDependencies = [
        coreutils # uname, cut, df, stat, uptime
        findutils # find
        inetutils # ifconfig
        ipmitool # ipmitool
        nmap # nmap
        pciutils # lspci
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        dmidecode # dmidecode
        iproute2 # ip
        lvm2 # pvs
        usbutils # lsusb
        util-linux # last, lsblk, mount
      ];
    in
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      shortenPerlShebang $out/bin/ocsinventory-agent
    ''
    + ''
      wrapProgram $out/bin/ocsinventory-agent --prefix PATH : ${lib.makeBinPath runtimeDependencies}
    '';

  passthru = {
    tests = {
      inherit (nixosTests) ocsinventory-agent;
      version = testers.testVersion {
        package = ocsinventory-agent;
        command = "ocsinventory-agent --version";
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "OCS Inventory unified agent for Unix operating systems";
    longDescription = ''
      Open Computers and Software Inventory (OCS) is an application designed
      to help a network or system administrator to keep track of the hardware and
      software configurations of computers that are installed on the network.
    '';
    homepage = "https://ocsinventory-ng.org";
    changelog = "https://github.com/OCSInventory-NG/UnixAgent/releases/tag/v${version}";
    downloadPage = "https://github.com/OCSInventory-NG/UnixAgent/releases";
    license = lib.licenses.gpl2Only;
    mainProgram = "ocsinventory-agent";
    maintainers = with lib.maintainers; [
      totoroot
      anthonyroussel
    ];
    platforms = lib.platforms.unix;
  };
}

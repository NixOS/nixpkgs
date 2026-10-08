{
  lib,
  stdenv,
  coreutils,
  dmidecode,
  fetchFromGitHub,
  findutils,
  inetutils,
  ipmitool,
  iproute2,
  lvm2,
  makeWrapper,
  nix-update-script,
  nixosTests,
  nmap,
  pciutils,
  perlPackages,
  usbutils,
  util-linux,
  versionCheckHook,
  which,
}:

perlPackages.buildPerlPackage rec {
  pname = "ocsinventory-agent";
  version = "2.10.5";

  src = fetchFromGitHub {
    owner = "OCSInventory-NG";
    repo = "UnixAgent";
    tag = "v${version}";
    hash = "sha256-BIR93ABiE3wzuw9Q0fZMm7ClKyDmsxE+UcPTYd6P7No=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

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
        which # which
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        dmidecode # dmidecode
        iproute2 # ip
        lvm2 # pvs
        usbutils # lsusb
        util-linux # last, lsblk, mount
      ];
    in
    ''
      wrapProgram $out/bin/ocsinventory-agent --prefix PATH : ${lib.makeBinPath runtimeDependencies}
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests.ocsinventory-agent = nixosTests.ocsinventory-agent;
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
    license = lib.licenses.gpl2Plus;
    mainProgram = "ocsinventory-agent";
    maintainers = with lib.maintainers; [
      totoroot
      anthonyroussel
    ];
    platforms = lib.platforms.unix;
  };
}

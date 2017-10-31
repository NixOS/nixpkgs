{ stdenv, writeText, dosfstools, mtools }:

{ productKey
, shExecAfterwards ? "E:\\bootstrap.sh"
, cygwinRoot ? "C:\\cygwin"
, cygwinSetup ? "E:\\setup.exe"
, cygwinRepository ? "E:\\"
, cygwinPackages ? [ "openssh" ]
}:

let
  afterSetup = [
    cygwinSetup
    "-L -n -q"
    "-l ${cygwinRepository}"
    "-R ${cygwinRoot}"
    "-C base"
  ] ++ map (p: "-P ${p}") cygwinPackages;

  winXpUnattended = writeText "winnt.sif" ''
    [Data]
    AutoPartition = 1
    AutomaticUpdates = 0
    MsDosInitiated = 0
    UnattendedInstall = Yes

    [Unattended]
    DUDisable = Yes
    DriverSigningPolicy = Ignore
    Hibernation = No
    OemPreinstall = No
    OemSkipEula = Yes
    Repartition = Yes
    TargetPath = \WINDOWS
    UnattendMode = FullUnattended
    UnattendSwitch = Yes
    WaitForReboot = No

    [GuiUnattended]
    AdminPassword = "nopasswd"
    AutoLogon = Yes
    AutoLogonCount = 1
    OEMSkipRegional = 1
    OemSkipWelcome = 1
    ServerWelcome = No
    TimeZone = 85

    [UserData]
    ComputerName = "cygwin"
    FullName = "cygwin"
    OrgName = ""
    ProductKey = "${productKey}"

    [Networking]
    InstallDefaultComponents = Yes

    [Identification]
    JoinWorkgroup = cygwin

    [NetAdapters]
    PrimaryAdapter = params.PrimaryAdapter

    [params.PrimaryAdapter]
    InfID = *

    [params.MS_MSClient]

    [NetProtocols]
    MS_TCPIP = params.MS_TCPIP

    [params.MS_TCPIP]
    AdapterSections=params.MS_TCPIP.PrimaryAdapter

    [params.MS_TCPIP.PrimaryAdapter]
    DHCP = No
    IPAddress = 192.168.0.1
    SpecificTo = PrimaryAdapter
    SubnetMask = 255.255.255.0
    WINS = No

    ; Turn off all components
    [Components]
    ${stdenv.lib.concatMapStrings (comp: "${comp} = Off\n") [
      "AccessOpt" "Appsrv_console" "Aspnet" "BitsServerExtensionsISAPI"
      "BitsServerExtensionsManager" "Calc" "Certsrv" "Certsrv_client"
      "Certsrv_server" "Charmap" "Chat" "Clipbook" "Cluster" "Complusnetwork"
      "Deskpaper" "Dialer" "Dtcnetwork" "Fax" "Fp_extensions" "Fp_vdir_deploy"
      "Freecell" "Hearts" "Hypertrm" "IEAccess" "IEHardenAdmin" "IEHardenUser"
      "Iis_asp" "Iis_common" "Iis_ftp" "Iis_inetmgr" "Iis_internetdataconnector"
      "Iis_nntp" "Iis_serversideincludes" "Iis_smtp" "Iis_webdav" "Iis_www"
      "Indexsrv_system" "Inetprint" "Licenseserver" "Media_clips" "Media_utopia"
      "Minesweeper" "Mousepoint" "Msmq_ADIntegrated" "Msmq_Core"
      "Msmq_HTTPSupport" "Msmq_LocalStorage" "Msmq_MQDSService"
      "Msmq_RoutingSupport" "Msmq_TriggersService" "Msnexplr" "Mswordpad"
      "Netcis" "Netoc" "OEAccess" "Objectpkg" "Paint" "Pinball" "Pop3Admin"
      "Pop3Service" "Pop3Srv" "Rec" "Reminst" "Rootautoupdate" "Rstorage" "SCW"
      "Sakit_web" "Solitaire" "Spider" "TSWebClient" "Templates"
      "TerminalServer" "UDDIAdmin" "UDDIDatabase" "UDDIWeb" "Vol" "WMAccess"
      "WMPOCM" "WbemMSI" "Wms" "Wms_admin_asp" "Wms_admin_mmc" "Wms_isapi"
      "Wms_server" "Zonegames"
    ]}

    [WindowsFirewall]
    Profiles = WindowsFirewall.TurnOffFirewall

    [WindowsFirewall.TurnOffFirewall]
    Mode = 0

    [SetupParams]
    UserExecute = "${stdenv.lib.concatStringsSep " " afterSetup}"

    [GuiRunOnce]
    Command0 = "${cygwinRoot}\bin\bash -l ${shExecAfterwards}"
  '';

in stdenv.mkDerivation {
  name = "unattended-floppy.img";
  buildCommand = ''
    dd if=/dev/zero of="$out" count=1440 bs=1024
    ${dosfstools}/sbin/mkfs.msdos "$out"
    ${mtools}/bin/mcopy -i "$out" "${winXpUnattended}" ::winnt.sif
  '';
}

{
  config,
  lib,
  utils,
  pkgs,
  ...
}:
let
  cfg = config.services.amule;

  settingsFormat = pkgs.formats.ini { };

  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    types
    optionalAttrs
    mkIf
    mkMerge
    recursiveUpdate
    literalExpression
    optionalString
    optionals
    getExe
    ;

  defaultSettings = {
    eMule = {
      AppVersion = cfg.package.version;
      Nick = "http://www.aMule.org";
      QueueSizePref = 50;
      MaxUpload = 0;
      MaxDownload = 0;
      SlotAllocation = 2;
      Port = null;
      UDPPort = null;
      UDPEnable = 1;
      Address = "";
      Autoconnect = 1;
      MaxSourcesPerFile = 300;
      MaxConnections = 500;
      MaxConnectionsPerFiveSeconds = 20;
      RemoveDeadServer = 1;
      DeadServerRetry = 3;
      ServerKeepAliveTimeout = 0;
      Reconnect = 1;
      Scoresystem = 1;
      Serverlist = 0;
      AddServerListFromServer = 0;
      AddServerListFromClient = 0;
      SafeServerConnect = 0;
      AutoConnectStaticOnly = 0;
      UPnPEnabled = 0;
      UPnPTCPPort = 50000;
      SmartIdCheck = 1;
      ConnectToKad = 1;
      ConnectToED2K = 1;
      TempDir = null;
      IncomingDir = null;
      ICH = 1;
      AICHTrust = 0;
      CheckDiskspace = 1;
      MinFreeDiskSpace = 1;
      AddNewFilesPaused = 0;
      PreviewPrio = 0;
      ManualHighPrio = 0;
      StartNextFile = 0;
      StartNextFileSameCat = 0;
      StartNextFileAlpha = 0;
      FileBufferSizePref = 16;
      DAPPref = 1;
      UAPPref = 1;
      AllocateFullFile = 0;
      OSDirectory = null;
      OnlineSignature = 0;
      OnlineSignatureUpdate = 5;
      EnableTrayIcon = 0;
      MinToTray = 0;
      Notifications = 0;
      ConfirmExit = 1;
      StartupMinimized = 0;
      "3DDepth" = 10;
      ToolTipDelay = 1;
      ShowOverhead = 0;
      ShowInfoOnCatTabs = 1;
      VerticalToolbar = 0;
      GeoIPEnabled = 1;
      ShowVersionOnTitle = 0;
      VideoPlayer = "";
      StatGraphsInterval = 3;
      statsInterval = 30;
      DownloadCapacity = 300;
      UploadCapacity = 100;
      StatsAverageMinutes = 5;
      VariousStatisticsMaxValue = 100;
      SeeShare = 2;
      FilterLanIPs = 1;
      ParanoidFiltering = 1;
      IPFilterAutoLoad = 1;
      IPFilterURL = "";
      FilterLevel = 127;
      IPFilterSystem = 0;
      FilterMessages = 1;
      FilterAllMessages = 0;
      MessagesFromFriendsOnly = 0;
      MessageFromValidSourcesOnly = 1;
      FilterWordMessages = 0;
      MessageFilter = "";
      ShowMessagesInLog = 1;
      FilterComments = 0;
      CommentFilter = "";
      ShareHiddenFiles = 1;
      AutoSortDownloads = 0;
      NewVersionCheck = 1;
      AdvancedSpamFilter = 1;
      MessageUseCaptchas = 1;
      Language = "";
      SplitterbarPosition = 75;
      YourHostname = "";
      DateTimeFormat = "%A, %x, %X";
      AllcatType = 0;
      ShowAllNotCats = 0;
      SmartIdState = 1;
      DropSlowSources = 0;
      KadNodesUrl = "http://upd.emule-security.org/nodes.dat";
      Ed2kServersUrl = "http://upd.emule-security.org/server.met";
      ShowRatesOnTitle = 0;
      GeoLiteCountryUpdateUrl = "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz";
      StatsServerName = "Shorty's ED2K stats";
      StatsServerURL = "http://ed2k.shortypower.dyndns.org/?hash=";
      CreateSparseFiles = 1;
    };
    Browser = {
      OpenPageInTab = 1;
      CustomBrowserString = "";
    };
    Proxy = {
      ProxyEnableProxy = 0;
      ProxyType = 0;
      ProxyName = "";
      ProxyPort = 1080;
      ProxyEnablePassword = 0;
      ProxyUser = "";
      ProxyPassword = "";
    };
    ExternalConnect = {
      UseSrcSeeds = 0;
      AcceptExternalConnections = 1;
      ECAddress = "";
      ECPort = null;
      ECPassword = "";
      UPnPECEnabled = 0;
      ShowProgressBar = 1;
      ShowPercent = 1;
      UseSecIdent = 1;
      IpFilterClients = 1;
      IpFilterServers = 1;
      TransmitOnlyUploadingClients = 0;
    };
    WebServer = {
      Enabled = null;
      Password = "";
      PasswordLow = "";
      Port = null;
      WebUPnPTCPPort = 50001;
      UPnPWebServerEnabled = 0;
      UseGzip = 1;
      UseLowRightsUser = 0;
      PageRefreshTime = 120;
      Template = "default";
      Path = "amuleweb";
    };
    GUI = {
      HideOnClose = 0;
    };
    Razor_Preferences = {
      FastED2KLinksHandler = 1;
    };
    SkinGUIOptions = {
      Skin = "";
    };
    Statistics = {
      MaxClientVersions = 0;
    };
    Obfuscation = {
      IsClientCryptLayerSupported = 1;
      IsCryptLayerRequested = 1;
      IsClientCryptLayerRequired = 0;
      CryptoPaddingLenght = 254;
      CryptoKadUDPKey = "";
    };
    PowerManagement = {
      PreventSleepWhileDownloading = 0;
    };
    "UserEvents/DownloadCompleted" = {
      CoreEnabled = 0;
      CoreCommand = "";
      GUIEnabled = 0;
      GUICommand = "";
    };
    "UserEvents/NewChatSession" = {
      CoreEnabled = 0;
      CoreCommand = "";
      GUIEnabled = 0;
      GUICommand = "";
    };
    "UserEvents/OutOfDiskSpace" = {
      CoreEnabled = 0;
      CoreCommand = "";
      GUIEnabled = 0;
      GUICommand = "";
    };
    "UserEvents/ErrorOnCompletion" = {
      CoreEnabled = 0;
      CoreCommand = "";
      GUIEnabled = 0;
      GUICommand = "";
    };
    HTTPDownload = {
      URL_1 = "";
    };
  };

  settingsOptions = {
    eMule = {
      Port = mkOption {
        type = types.port;
        default = 4662;
        description = ''
          TCP port for eD2k connections.
          Required for connecting to servers and achieving a High ID.
        '';
      };
      UDPPort = mkOption {
        type = types.port;
        default = 4672;
        description = ''
          UDP port for eD2k traffic (searches, source exchange) and all Kad network communication.
          Essential for a High ID on both networks and proper Kad functioning.
        '';
      };
      TempDir = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/Temp";
        defaultText = literalExpression "\${config.services.amule.dataDir}/Temp";
        description = ''
          Directory where aMule stores incomplete downloads (.part/.part.met files).
          Ensure the aMule service has write permissions.
        '';
      };
      IncomingDir = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/Incoming";
        defaultText = literalExpression "\${config.services.amule.dataDir}/Incoming";
        description = ''
          Directory where aMule moves completed downloads.
          Files in this directory are automatically shared.
          Ensure the aMule service has write permissions
        '';
      };
      OSDirectory = mkOption {
        type = types.path;
        default = cfg.dataDir;
        defaultText = literalExpression "\${config.services.amule.dataDir}";
        description = "On-disk state directory, probably you don't want to change this";
      };
    };
    ExternalConnect = {
      ECPort = mkOption {
        type = types.port;
        default = 4712;
        description = "TCP port for external connections, like remote control via amule-gui";
      };
      ECPassword = mkOption {
        type = types.str;
        default = "";
        description = ''
          MD5 hash of the password, obtainaible with `echo "<password>" | md5sum | cut -d ' ' -f 1`
        '';
      };
    };
    WebServer = {
      Enabled = lib.mkOption {
        type = types.enum [
          0
          1
        ];
        default = 0;
        description = "Set to 1 to enable the web server";
      };
      Password = mkOption {
        type = types.str;
        default = "";
        description = ''
          MD5 hash of the password, obtainaible with `echo "<password>" | md5sum | cut -d ' ' -f 1`
        '';
      };
      Port = mkOption {
        type = types.port;
        default = 4711;
        description = "Web server port";
      };
    };
  };

  finalSettings = recursiveUpdate defaultSettings cfg.settings;

  webServerEnabled = cfg.settings.WebServer.Enabled == 1;
in
{
  options.services.amule = {
    enable = mkEnableOption "aMule daemon";

    package = mkPackageOption pkgs "amule-daemon" { };

    amuleWebPackage = mkPackageOption pkgs "amule-web" { };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional passed arguments";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/amuled";
      description = "Directory holding configuration and by default also incoming and temporary files";
    };

    user = mkOption {
      type = types.str;
      default = "amule";
      description = "The user the aMule daemon should run as";
    };

    group = mkOption {
      type = types.str;
      default = "amule";
      description = "Group under which amule runs";
    };

    openPeerPorts = mkEnableOption "open the peer port(s) in the firewall";

    openExternalConnectPort = mkEnableOption "open the external connect port";

    openWebServerPort = mkEnableOption "open the web server port";

    ExternalConnectPasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        File containing the password for connecting with amule-gui,
        set this only if you didn't set `settings.ExternalConnect.ECPassword`
      '';
    };

    WebServerPasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        File containing the password for connecting to the web server,
        set this only if you didn't set `settings.ExternalConnect.ECPassword`
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = settingsOptions;
      };
      description = ''
        Free form attribute set for aMule settings.
        The final configuration file is generated merging the default settings with these options.
      '';
      example = literalExpression ''
        {
          eMule = {
            IncomingDir = "/mnt/hd/amule/Incoming";
            TempDir = "/mnt/hd/amule/Temp";
          };
          WebServer.Enabled = 1;
        }
      '';
      default = { };
    };

    configurationFile = mkOption {
      type = types.path;
      description = ''
        INI configuration file for aMule.
        By default it's generated merging `services.amule.settings` with the default options.
        Change only if you want to provide your own INI configuration file ignoring the `settings` option.
      '';
      default = settingsFormat.generate "amule.conf" finalSettings;
      defaultText = literalExpression ''settingsFormat.generate "amule.conf" finalSettings'';
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [
        {
          assertion = isNull cfg.ExternalConnectPasswordFile -> cfg.settings.ExternalConnect.ECPassword != "";
          message = "Set only one between `ExternalConnectPasswordFile` and `settings.ExternalConnect.ECPassword`";
        }
      ]
      ++ optionals webServerEnabled [
        {
          assertion = isNull cfg.WebServerPasswordFile -> cfg.settings.WebServer.Password != "";
          message = "Set only one between `ExternalWebServerFile` `settings.WebServer.Password`";
        }
      ];

    users.users = optionalAttrs (cfg.user == "amule") {
      amule = {
        group = cfg.group;
        description = "aMule user";
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == "amule") {
      amule = { };
    };

    systemd.tmpfiles.settings."10-amuled".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0755";
    };

    systemd.services.amuled = {
      description = "AMule daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        ExecStartPre = pkgs.writeShellScript "amule-daemon-prestart.sh" (
          ''
            set -e

            cp -f ${cfg.configurationFile} ${cfg.dataDir}/amule.conf
          ''
          + optionalString (!isNull cfg.ExternalConnectPasswordFile) ''
            EC_PASSWORD=$(cat ${cfg.ExternalConnectPasswordFile} | md5sum | cut -d ' ' -f 1)
            sed -Ei "s/^ECPassword=.*/ECPassword=$EC_PASSWORD/" ${cfg.dataDir}/amule.conf
          ''
          + optionalString (!isNull cfg.WebServerPasswordFile) ''
            WEB_PASSWORD=$(cat ${cfg.WebServerPasswordFile} | md5sum | cut -d ' ' -f 1)
            sed -Ei "s/^Password=.*/Password=$WEB_PASSWORD/" ${cfg.dataDir}/amule.conf
          ''
        );
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (getExe cfg.package)
            "--config-dir"
            cfg.dataDir
          ]
          ++ optionals webServerEnabled [ "--use-amuleweb=${getExe cfg.amuleWebPackage}" ]
          ++ cfg.extraArgs
        );

        Restart = "on-failure";
        RestartSec = "5s";

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ReadWritePaths = [
          cfg.dataDir
          cfg.settings.eMule.TempDir
          cfg.settings.eMule.IncomingDir
        ];
        RestrictAddressFamilies = "AF_INET";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
      };
    };

    networking.firewall = mkMerge [
      (mkIf cfg.openPeerPorts {
        allowedTCPPorts = [ cfg.settings.eMule.Port ];
        allowedUDPPorts = [ cfg.settings.eMule.UDPPort ];
      })
      (mkIf cfg.openWebServerPort {
        allowedTCPPorts = [ cfg.settings.WebServer.Port ];
      })
    ];
  };

  meta = {
    maintainers = with lib.maintainers; [ aciceri ];
    doc = ./amuled.md;
  };
}

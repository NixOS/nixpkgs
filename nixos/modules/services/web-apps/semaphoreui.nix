{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.semaphoreui;

  format = pkgs.formats.json { };

  configFile = format.generate "config.json" (
    {
      port = toString cfg.port;
      interface = cfg.interface;
      tmp_path = cfg.tmpPath;
      cookie_hash = cfg.cookieHash;
      cookie_encryption = cfg.cookieEncryption;
      access_key_encryption = cfg.accessKeyEncryption;
      email_sender = cfg.email.sender;
      email_host = cfg.email.host;
      email_port = cfg.email.port;
      web_host = cfg.webHost;
      ldap_binddn = cfg.ldap.bindDn;
      ldap_bindpassword = cfg.ldap.bindPassword;
      ldap_server = cfg.ldap.server;
      ldap_searchdn = cfg.ldap.searchDn;
      ldap_searchfilter = cfg.ldap.searchFilter;
      ldap_mappings = cfg.ldap.mappings;
      telegram_chat = cfg.telegram.chat;
      telegram_token = cfg.telegram.token;
      concurrency_mode = cfg.concurrencyMode;
      max_parallel_tasks = cfg.maxParallelTasks;
      ssh_config_path = cfg.sshConfigPath;
      demo_mode = cfg.demoMode;
    }
    // (lib.optionalAttrs (cfg.database.type == "mysql") {
      mysql = {
        host = cfg.database.host;
        user = cfg.database.user;
        pass = cfg.database.password;
        name = cfg.database.name;
        options = cfg.database.options;
      };
    })
    // (lib.optionalAttrs (cfg.database.type == "bolt") {
      bolt = {
        host = cfg.database.boltPath;
      };
    })
  );

in
{
  options.services.semaphoreui = {
    enable = lib.mkEnableOption (lib.mdDoc "SemaphoreUI service");

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.semaphoreui;
      defaultText = lib.literalExpression "pkgs.semaphoreui";
      description = lib.mdDoc "The SemaphoreUI package to use.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "semaphore";
      description = lib.mdDoc "User account under which SemaphoreUI runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "semaphore";
      description = lib.mdDoc "Group account under which SemaphoreUI runs.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = lib.mdDoc "Port on which SemaphoreUI listens.";
    };

    interface = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = lib.mdDoc "Interface on which SemaphoreUI listens. Empty string means all interfaces.";
    };

    tmpPath = lib.mkOption {
      type = lib.types.str;
      default = "/tmp/semaphore";
      description = lib.mdDoc "Path for temporary files.";
    };

    webHost = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:3000";
      description = lib.mdDoc "Web host URL for SemaphoreUI.";
    };

    cookieHash = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc "Cookie hash key for session security.";
    };

    cookieEncryption = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc "Cookie encryption key.";
    };

    accessKeyEncryption = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc "Access key encryption key.";
    };

    concurrencyMode = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = lib.mdDoc "Concurrency mode (project, node, or empty for no limit).";
    };

    maxParallelTasks = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = lib.mdDoc "Maximum number of parallel tasks (0 for unlimited).";
    };

    demoMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc "Enable demo mode.";
    };

    sshConfigPath = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = lib.mdDoc "Path to SSH config file.";
    };

    database = {
      type = lib.mkOption {
        type = lib.types.enum [
          "bolt"
          "mysql"
        ];
        default = "bolt";
        description = lib.mdDoc "Database type to use. 'bolt' for file-based database, 'mysql' for MySQL/MariaDB.";
      };

      boltPath = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/semaphore/semaphore.bolt";
        description = lib.mdDoc "Path to BoltDB database file (only used when database.type is 'bolt').";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1:3306";
        description = lib.mdDoc "Database host and port (only used when database.type is 'mysql').";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "semaphore";
        description = lib.mdDoc "Database user (only used when database.type is 'mysql').";
      };

      password = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "Database password (only used when database.type is 'mysql').";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "semaphore";
        description = lib.mdDoc "Database name (only used when database.type is 'mysql').";
      };

      options = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          parseTime = "true";
          interpolateParams = "true";
        };
        description = lib.mdDoc "Additional database options (only used when database.type is 'mysql').";
      };
    };

    email = {
      sender = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "Email sender address.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "SMTP host.";
      };

      port = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "SMTP port.";
      };
    };

    ldap = {
      bindDn = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "LDAP bind DN.";
      };

      bindPassword = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "LDAP bind password.";
      };

      server = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "LDAP server URL.";
      };

      searchDn = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "LDAP search DN.";
      };

      searchFilter = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "LDAP search filter.";
      };

      mappings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = lib.mdDoc "LDAP attribute mappings.";
      };
    };

    telegram = {
      chat = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "Telegram chat ID for notifications.";
      };

      token = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc "Telegram bot token.";
      };
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/semaphore";
      description = lib.mdDoc "Directory to store SemaphoreUI state.";
    };

    playbookPath = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/semaphore/playbooks";
      description = lib.mdDoc "Path where Ansible playbooks are stored.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc "Whether to open the firewall for SemaphoreUI.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.cookieHash != "";
        message = "services.semaphoreui.cookieHash must be set";
      }
      {
        assertion = cfg.cookieEncryption != "";
        message = "services.semaphoreui.cookieEncryption must be set";
      }
      {
        assertion = cfg.accessKeyEncryption != "";
        message = "services.semaphoreui.accessKeyEncryption must be set";
      }
      {
        assertion = cfg.database.type == "bolt" || cfg.database.password != "";
        message = "services.semaphoreui.database.password must be set when using MySQL database";
      }
    ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.stateDir;
      createHome = true;
      description = "SemaphoreUI service user";
    };

    users.groups.${cfg.group} = { };

    environment.systemPackages = [
      cfg.package
      pkgs.ansible
      pkgs.python3
      pkgs.git
      pkgs.openssh
      # Helper script for initial setup
      (pkgs.writeShellScriptBin "semaphore-setup" ''
        set -e
        echo "SemaphoreUI Setup Helper"
        echo "========================"
        echo ""
        echo "Database type: ${cfg.database.type}"
        ${
          if cfg.database.type == "bolt" then
            ''
              echo "Using BoltDB file: ${cfg.database.boltPath}"
              echo ""
              echo "Before running SemaphoreUI for the first time, you need to:"
              echo "1. Run database migrations with: sudo -u ${cfg.user} ${cfg.package}/bin/semaphore migrate --config=${configFile}"
              echo "2. Create an admin user with: sudo -u ${cfg.user} ${cfg.package}/bin/semaphore user add --admin --login admin --name Admin --email admin@localhost --password PASSWORD --config=${configFile}"
            ''
          else
            ''
              echo "Using MySQL database: ${cfg.database.host}/${cfg.database.name}"
              echo ""
              echo "Before running SemaphoreUI for the first time, you need to:"
              echo "1. Set up your MySQL/MariaDB database"
              echo "2. Run database migrations with: sudo -u ${cfg.user} ${cfg.package}/bin/semaphore migrate --config=${configFile}"
              echo "3. Create an admin user with: sudo -u ${cfg.user} ${cfg.package}/bin/semaphore user add --admin --login admin --name Admin --email admin@localhost --password PASSWORD --config=${configFile}"
            ''
        }
        echo ""
        echo "Configuration file is located at: ${configFile}"
        echo "State directory: ${cfg.stateDir}"
        echo "Playbooks directory: ${cfg.playbookPath}"
        echo ""
        echo "After setup, start the service with: sudo systemctl start semaphoreui"
        echo "Enable autostart with: sudo systemctl enable semaphoreui"
      '')
    ];

    # Create directories with proper permissions using systemd tmpfiles
    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.tmpPath} 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.playbookPath} 0755 ${cfg.user} ${cfg.group} -"
      # Ensure the directory for BoltDB file exists
      "d ${lib.dirOf cfg.database.boltPath} 0755 ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.semaphoreui = {
      description = "SemaphoreUI - Modern UI for Ansible";
      documentation = [ "https://docs.semaphoreui.com/" ];
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "systemd-tmpfiles-setup.service"
      ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/semaphore server --config=${configFile} --log-level DEBUG";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "always";
        RestartSec = 10;

        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [
          cfg.stateDir
          cfg.tmpPath
          cfg.playbookPath
          (lib.dirOf cfg.database.boltPath)
        ];

        WorkingDirectory = cfg.stateDir;

        Environment = [
          "HOME=${cfg.stateDir}"
        ];
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ vysakh ];
}

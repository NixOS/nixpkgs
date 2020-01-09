{ config, lib, pkgs, ... }:

with lib;
let
  user = "lool";
  group = "lool";
  dataDir = "/var/lib/lool";
  cfg = config.services.loolwsd;
  pkg = cfg.package;
  corePkg = pkg.passthru.libreoffice;
  subdir = corePkg.pname;
  cmdLineOpts = {
    sys_template_path = "${dataDir}/systemplate";
    child_root_path = "${dataDir}/child-roots";
    file_server_root_path = "${pkg}/share/loolwsd";
    "net.listen" = "loopback";
    "ssl.enable" = false;
    "ssl.termination" = true;
    "logging.level" = "information";
    "logging.anonymize.anonymize_user_data" = true;
    # LO treats allowed_languages as a list of prefixes, by taking the first two letters we
    # should be able to avoid mismatches of package name with the corresponding locale name
    "allowed_languages" = concatMapStringsSep " " (builtins.substring 0 2) cfg.dictionaries;
  } // cfg.settings;
  cmdLineVal = v: if v == true then "true" else if v == false then "false" else escapeShellArg v;

  sysTemplateSetup = ./loolwsd-systemplate-setup-nixos;
in
{
  options.services.loolwsd = with types; {
    enable = mkEnableOption "LibreOffice Online websocket daemon";

    configFile = mkOption {
      type = path;
      default = "${pkg}/etc/loolwsd/loolwsd.xml";
      defaultText = "\${config.services.loolwsd.package}/etc/loolwsd/loolwsd.xml";
      description = ''
        Path to loolwsd configuration file.
      '';
    };

    settings = mkOption {
      type = attrsOf (oneOf [ str bool int ]);
      default = {};
      example = literalExample ''
        { "logging.level" = "trace"; }
      '';
      description = ''
        Additional settings passed to loolwsd with the --override option.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.libreoffice-online;
      defaultText = "pkgs.libreoffice-online";
      relatedPackages = [ "libreoffice-online" ];
      description = ''
        LibreOffice Online package.
      '';
    };

    dictionaries = mkOption {
      type = listOf str;
      default = [];
      example = [ "en_GB-ize" "cs_CZ" ];
      description = ''
        List of Hunspell dictionaries to include for spellchecking functionality.

        The values must be names of attributes in <varname>pkgs.hunspellDicts</varname>.
      '';
    };

    proxy = {
      enable = mkEnableOption "nginx proxy for loolwsd daemon";

      hostname = mkOption {
        type = str;
        example = "lool.example.com";
        description = ''
          Hostname that will be used to access loolwsd.

          This automatically enables <option>forceSSL</option> and <option>forceSSL</option>
          for the corresponding virtual host. You can customize the virtual host using
          <option>services.nginx.virtualHosts.&lt;hostname&gt;</option>.

          When using with Nextcloud it is safe to set this to the value of
          <option>services.nextcloud.hostName</option>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = map (dict: {
      assertion = hasAttr dict pkgs.hunspellDicts;
      message = "dictionary package pkgs.hunspellDicts.${dict} does not exist";
    }) cfg.dictionaries;

    environment.systemPackages = [ pkg ]; # for manual pages

    # All system-wide configured (ttf) fonts are provided. You can add more using fonts.fonts.
    fonts.fontconfig.enable = true;
    fonts.enableDefaultFonts = true;

    systemd.services.loolwsd = {
      path = [ pkgs.nix ];
      description = "LibreOffice Online WebSocket Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        LOOL_FORKIT_PATH = "/run/wrappers/bin/loolforkit";
        DICPATH = concatMapStringsSep ":" (d: "${pkgs.hunspellDicts.${d}}/share/hunspell") cfg.dictionaries;
      };

      # The chroot template is copied to /var/lib/lool so that loolwsd can hardlink it to child roots.
      # Libreoffice lib directory (lotemplate) is kept separately because loolwsd expects that.
      preStart = ''
        rm -rf ${dataDir}/child-roots/*
        if [ ! -L ${dataDir}/core  ] || [ "$(readlink ${dataDir}/core)" != "${corePkg}" ]; then
          echo "Matching LibreOffice version not found, reinitializing systemplate, this may take a while ..."
          rm -rf ${dataDir}/{core,systemplate,lotemplate}

          ${pkgs.runtimeShell} ${sysTemplateSetup} ${dataDir}/systemplate ${corePkg}/lib/${subdir}
          find ${dataDir}/systemplate -type d -exec chmod u+wx '{}' +
          mv ${dataDir}/systemplate${corePkg}/lib/${subdir} ${dataDir}/lotemplate
          rm -rf ${dataDir}/systemplate${corePkg}

          ln -s ${corePkg} ${dataDir}/core
        fi
      '';

      serviceConfig = {
        User = user;
        Group = group;
        WorkingDirectory = dataDir;
        ExecStart = ''
          ${pkg}/bin/loolwsd \
            --version \
            --config-file=${cfg.configFile} \
            ${concatStringsSep " \\\n  " (flip mapAttrsToList cmdLineOpts (name: value: "-o:${name}=${cmdLineVal value}"))}
        '';

        KillMode = "control-group";
        KillSignal = "SIGINT";
        Restart = "always";

        TimeoutStartSec = "20min"; # initializing systemplate sometimes takes a lot of time
        TimeoutStopSec = "120s";

        StateDirectory = "lool";
        StateDirectoryMode = "0750";

        # As LOOL security model relies on file-based capabilities we can't use
        # NoNewPrivileges which is needed for most other sandboxing options.
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        ProtectControlGroups = true;

        # The CAP_SETPCAP is implicitly added by security.wrappers and
        # execve(loolforkit) returns EPERM unless it's also included here.
        CapabilityBoundingSet = [ "CAP_CHOWN" "CAP_FOWNER" "CAP_MKNOD" "CAP_SYS_CHROOT" "CAP_SETPCAP" ];
      };
    };

    security.wrappers = {
      loolforkit = {
        source = "${pkg}/bin/loolforkit";
        capabilities = "cap_chown,cap_fowner,cap_mknod,cap_sys_chroot=ep";
      };
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir}             0750 ${user} ${group} -   -"
      "d ${dataDir}/systemplate 0750 ${user} ${group} -   -"
      "d ${dataDir}/child-roots 0750 ${user} ${group} -   -"
      "d /var/cache/loolwsd     0750 ${user} ${group} 10d -"
    ];

    users.users.${user} = {
      group = group;
      home = dataDir;
      isSystemUser = true;
    };

    users.groups.${group} = {};

    services.nginx = mkIf cfg.proxy.enable {
      enable = true;

      virtualHosts.${cfg.proxy.hostname} = mkIf cfg.proxy.enable {
        forceSSL = mkDefault true;
        enableACME = mkDefault true;

        # extraConfig is used instead of location."..." attributes because the latter does not
        # preserve the order of the locations which matters if regular expressions are used.
        extraConfig = ''
          # static files
          location ^~ /loleaflet {
              proxy_pass http://[::1]:9980;
              proxy_set_header Host $host;
          }

          # WOPI discovery URL
          location ^~ /hosting/discovery {
              proxy_pass http://[::1]:9980;
              proxy_set_header Host $host;
          }

          # Capabilities
          location ^~ /hosting/capabilities {
              proxy_pass http://[::1]:9980;
              proxy_set_header Host $host;
          }

          # main websocket
          location ~ ^/lool/(.*)/ws$ {
              proxy_pass http://[::1]:9980;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Host $host;
              proxy_read_timeout 36000s;
          }

          # download, presentation and image upload
          location ~ ^/lool {
              proxy_pass http://[::1]:9980;
              proxy_set_header Host $host;
          }

          # Admin Console websocket
          location ^~ /lool/adminws {
              proxy_pass http://[::1]:9980;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Host $host;
              proxy_read_timeout 36000s;
          }
        '';
      };
    };
  };
}

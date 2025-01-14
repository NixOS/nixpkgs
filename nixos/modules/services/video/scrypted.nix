{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.scrypted;

  python312Packages =
    python-pkgs: with python-pkgs; [
      pip
      setuptools
      wheel
      debugpy
      gst-python
    ];

  python39Packages =
    python-pkgs: with python-pkgs; [
      pip
      debugpy
    ];

  python312 = pkgs.python312.withPackages python312Packages;
  python39 = pkgs.python39.withPackages python39Packages;

  gstPlugins = with pkgs.gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-libav
    gst-vaapi
  ];
in
{
  options.services.scrypted = {
    enable = lib.mkEnableOption "Scrypted home automation server";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The scrypted package to use";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open ports 11080 and 10443 in the firewall";
    };

    installPath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/scrypted";
      description = "Directory where scrypted data will be stored";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "scrypted";
      description = "User account under which scrypted runs";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "scrypted";
      description = "Group account under which scrypted runs";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Environment file to load additional environment variables from";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Additional environment variables for scrypted";
      example = lib.literalExpression ''
        {
          SCRYPTED_NVR_VOLUME = "/var/lib/scrypted/nvr";
          SCRYPTED_SECURE_PORT = 443;
          SCRYPTED_INSECURE_PORT = 8080;
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.scrypted = {
      description = "Scrypted home automation server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = lib.mkMerge [
        {
          SCRYPTED_CAN_RESTART = "true";
          SCRYPTED_INSTALL_PATH = cfg.installPath;
          SCRYPTED_VOLUME = "${cfg.installPath}/volume";
          SCRYPTED_PYTHON_PATH = "${lib.getExe python312}";
          SCRYPTED_PYTHON39_PATH = "${lib.getExe python39}";
          SCRYPTED_PYTHON312_PATH = "${lib.getExe python312}";
          SCRYPTED_FFMPEG_PATH = "${lib.getExe pkgs.ffmpeg}";

          LD_LIBRARY_PATH = lib.makeLibraryPath [
            pkgs.gcc-unwrapped.lib
            pkgs.tensorflow-lite
          ];

          GST_PLUGIN_PATH = lib.makeSearchPath "lib/gstreamer-1.0" gstPlugins;
        }
        cfg.extraEnvironment
      ];

      path = [
        python39
        python312
        pkgs.ffmpeg
        pkgs.gcc-unwrapped.lib
        pkgs.gobject-introspection
        pkgs.tensorflow-lite
      ] ++ gstPlugins;

      serviceConfig =
        {
          ExecStart = "${lib.getExe cfg.package}";
          Restart = "always";
          RestartSec = "3";

          User = cfg.user;
          Group = cfg.group;

          StateDirectory = "scrypted";
          StateDirectoryMode = "0750";

          ProtectSystem = "strict";
          ProtectHome = true;
          WorkingDirectory = cfg.installPath;
          ReadWritePaths = [ cfg.installPath ];
          PrivateDevices = false;
          PrivateTmp = true;
          NoNewPrivileges = true;
          RestrictRealtime = true;

          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];

        }
        // lib.optionalAttrs (cfg.environmentFile != null) {
          EnvironmentFile = cfg.environmentFile;
        };
    };

    users.users = lib.mkIf (cfg.user == "scrypted") {
      ${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.installPath;
        createHome = true;
        description = "Scrypted service user";
      };
    };

    users.groups = lib.mkIf (cfg.group == "scrypted") { ${cfg.group} = { }; };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        11080
        10443
      ];
    };
  };
}

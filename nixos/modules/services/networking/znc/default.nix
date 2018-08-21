{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.znc;

  defaultUser = "znc"; # Default user to own process.

  modules = pkgs.buildEnv {
    name = "znc-modules";
    paths = cfg.modulePackages;
  };

in

{

  imports = [
    ./options.nix
  ];

  ###### Interface

  options = {
    services.znc = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable a ZNC service for a user.
        '';
      };

      user = mkOption {
        default = "znc";
        example = "john";
        type = types.string;
        description = ''
          The name of an existing user account to use to own the ZNC server process.
          If not specified, a default user will be created to own the process.
        '';
      };

      group = mkOption {
        default = "";
        example = "users";
        type = types.string;
        description = ''
          Group to own the ZNCserver process.
        '';
      };

      dataDir = mkOption {
        default = "/var/lib/znc/";
        example = "/home/john/.znc/";
        type = types.path;
        description = ''
          The data directory. Used for configuration files and modules.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for ZNC.
        '';
      };

      modulePackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExample "[ pkgs.zncModules.fish pkgs.zncModules.push ]";
        description = ''
          A list of global znc module packages to add to znc.
        '';
      };

      mutable = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Indicates whether to allow the contents of the `dataDir` directory to be changed
          by the user at run-time.
          If true, modifications to the ZNC configuration after its initial creation are not
            overwritten by a NixOS system rebuild.
          If false, the ZNC configuration is rebuilt by every system rebuild.
          If the user wants to manage the ZNC service using the web admin interface, this value
            should be set to true.
        '';
      };

      extraFlags = mkOption {
        default = [ ];
        example = [ "--debug" ];
        type = types.listOf types.str;
        description = ''
          Extra flags to use when executing znc command.
        '';
      };
    };
  };


  ###### Implementation

  config = mkIf cfg.enable {

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ ]; # TODO: Add port
    };

    systemd.services.znc = {
      description = "ZNC Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.service" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop   = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
      };
      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -p ${cfg.dataDir}/configs

        # If mutable, regenerate conf file every time.
        ${optionalString (!cfg.mutable) ''
          ${pkgs.coreutils}/bin/echo "znc is set to be system-managed. Now deleting old znc.conf file to be regenerated."
          ${pkgs.coreutils}/bin/rm -f ${cfg.dataDir}/configs/znc.conf
        ''}

        # Ensure essential files exist.
        if [[ ! -f ${cfg.dataDir}/configs/znc.conf ]]; then
            ${pkgs.coreutils}/bin/echo "No znc.conf file found in ${cfg.dataDir}. Creating one now."
            ${pkgs.coreutils}/bin/cp --no-clobber ${/* TODO */"zncConfFile"} ${cfg.dataDir}/configs/znc.conf
            ${pkgs.coreutils}/bin/chmod u+rw ${cfg.dataDir}/configs/znc.conf
            ${pkgs.coreutils}/bin/chown ${cfg.user} ${cfg.dataDir}/configs/znc.conf
        fi

        if [[ ! -f ${cfg.dataDir}/znc.pem ]]; then
          ${pkgs.coreutils}/bin/echo "No znc.pem file found in ${cfg.dataDir}. Creating one now."
          ${pkgs.znc}/bin/znc --makepem --datadir ${cfg.dataDir}
        fi

        # Symlink modules
        rm ${cfg.dataDir}/modules || true
        ln -fs ${modules}/lib/znc ${cfg.dataDir}/modules
      '';
      script = "${pkgs.znc}/bin/znc --foreground --datadir ${cfg.dataDir} ${toString cfg.extraFlags}";
    };

    users.users = optional (cfg.user == defaultUser)
      { name = defaultUser;
        description = "ZNC server daemon owner";
        group = defaultUser;
        uid = config.ids.uids.znc;
        home = cfg.dataDir;
        createHome = true;
      };

    users.groups = optional (cfg.user == defaultUser)
      { name = defaultUser;
        gid = config.ids.gids.znc;
        members = [ defaultUser ];
      };

  };
}

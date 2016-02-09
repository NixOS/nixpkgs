{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gale;
  # we convert the path to a string to avoid it being copied to the nix store,
  # otherwise users could read the private key as all files in the store are
  # world-readable
  keyPath = toString cfg.keyPath;
  # ...but we refer to the pubkey file using a path so that we can ensure the
  # config gets rebuilt if the public key changes (we can assume the private key
  # will never change without the public key having changed)
  gpubFile = cfg.keyPath + "/${cfg.domain}.gpub";
  home = "/var/lib/gale";
  keysPrepared = cfg.keyPath != null && lib.pathExists cfg.keyPath;
in
{
  options = {
    services.gale = {
      enable = mkEnableOption "the Gale messaging daemon";

      user = mkOption {
        default = "gale";
        type = types.str;
        description = "Username for the Gale daemon.";
      };

      group = mkOption {
        default = "gale";
        type = types.str;
        description = "Group name for the Gale daemon.";
      };

      setuidWrapper = mkOption {
        default = null;
        description = "Configuration for the Gale gksign setuid wrapper.";
      };

      domain = mkOption {
        default = "";
        type = types.str;
        description = "Domain name for the Gale system.";
      };

      keyPath = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = ''
          Directory containing the key pair for this Gale domain.  The expected
          filename will be taken from the domain option with ".gpri" and ".gpub"
          appended.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Additional text to be added to <filename>/etc/gale/conf</filename>.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
       assertions = [{
         assertion = cfg.domain != "";
         message = "A domain must be set for Gale.";
       }];

       warnings = mkIf (!keysPrepared) [
         "You must run gale-install in order to generate a domain key."
       ];

       system.activationScripts.gale = mkIf cfg.enable (
         stringAfter [ "users" "groups" ] ''
           chmod 755 ${home}
           mkdir -m 0777 -p ${home}/auth/cache
           mkdir -m 1777 -p ${home}/auth/local # GALE_DOMAIN.gpub
           mkdir -m 0700 -p ${home}/auth/private # ROOT.gpub
           mkdir -m 0755 -p ${home}/auth/trusted # ROOT
           mkdir -m 0700 -p ${home}/.gale
           mkdir -m 0700 -p ${home}/.gale/auth
           mkdir -m 0700 -p ${home}/.gale/auth/private # GALE_DOMAIN.gpri

           ln -sf ${pkgs.gale}/etc/gale/auth/trusted/ROOT "${home}/auth/trusted/ROOT"
           chown ${cfg.user}:${cfg.group} ${home} ${home}/auth ${home}/auth/*
           chown ${cfg.user}:${cfg.group} ${home}/.gale ${home}/.gale/auth ${home}/.gale/auth/private
         ''
       );

       environment = {
         etc = {
           "gale/auth".source = home + "/auth"; # symlink /var/lib/gale/auth
           "gale/conf".text = ''
             GALE_USER ${cfg.user}
             GALE_DOMAIN ${cfg.domain}
             ${cfg.extraConfig}
           '';
         };

         systemPackages = [ pkgs.gale ];
       };

       users.extraUsers = [{
         name = cfg.user;
         description = "Gale daemon";
         uid = config.ids.uids.gale;
         group = cfg.group;
         home = home;
         createHome = true;
       }];

       users.extraGroups = [{
         name = cfg.group;
         gid = config.ids.gids.gale;
       }];
    })
    (mkIf (cfg.enable && keysPrepared) {
       assertions = [
         {
           assertion = cfg.keyPath != null
                    && lib.pathExists (cfg.keyPath + "/${cfg.domain}.gpub");
           message = "Couldn't find a Gale public key for ${cfg.domain}.";
         }
         {
           assertion = cfg.keyPath != null
                    && lib.pathExists (cfg.keyPath + "/${cfg.domain}.gpri");
           message = "Couldn't find a Gale private key for ${cfg.domain}.";
         }
       ];

       services.gale.setuidWrapper = {
         program = "gksign";
         source = "${pkgs.gale}/bin/gksign";
         owner = cfg.user;
         group = cfg.group;
         setuid = true;
         setgid = false;
       };

       security.setuidOwners = [ cfg.setuidWrapper ];

       systemd.services.gale-galed = {
         description = "Gale messaging daemon";
         wantedBy = [ "multi-user.target" ];
         wants = [ "gale-gdomain.service" ];
         after = [ "network.target" ];

         preStart = ''
           install -m 0640 -o ${cfg.user} -g ${cfg.group} ${keyPath}/${cfg.domain}.gpri "${home}/.gale/auth/private/"
           install -m 0644 -o ${cfg.user} -g ${cfg.group} ${gpubFile} "${home}/.gale/auth/private/${cfg.domain}.gpub"
           install -m 0644 -o ${cfg.user} -g ${cfg.group} ${gpubFile} "${home}/auth/local/${cfg.domain}.gpub"
         '';

         serviceConfig = {
           Type = "forking";
           ExecStart = "@${pkgs.gale}/bin/galed galed";
           User = cfg.user;
           Group = cfg.group;
           PermissionsStartOnly = true;
         };
       };

       systemd.services.gale-gdomain = {
         description = "Gale AKD daemon";
         wantedBy = [ "multi-user.target" ];
         requires = [ "gale-galed.service" ];
         after = [ "gale-galed.service" ];

         serviceConfig = {
           Type = "forking";
           ExecStart = "@${pkgs.gale}/bin/gdomain gdomain";
           User = cfg.user;
           Group = cfg.group;
         };
       };
    })
  ];
}

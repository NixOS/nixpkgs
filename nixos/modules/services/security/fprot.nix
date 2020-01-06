{ config, lib, pkgs, ... }:
with lib;
let
  fprotUser = "fprot";
  stateDir = "/var/lib/fprot";
  fprotGroup = fprotUser;
  cfg = config.services.fprot;
in {
  options = {

    services.fprot = {
      updater = {
        enable = mkOption {
          default = false;
          description = ''
            Whether to enable automatic F-Prot virus definitions database updates.
          '';
        };

        productData = mkOption {
          description = ''
            product.data file. Defaults to the one supplied with installation package.
          '';
        };

        frequency = mkOption {
          default = 30;
          description = ''
            Update virus definitions every X minutes.
          '';
        };

        licenseKeyfile = mkOption {
          description = ''
            License keyfile. Defaults to the one supplied with installation package.
          '';
        };

      };
    };
  };

  ###### implementation

  config = mkIf cfg.updater.enable {

    services.fprot.updater.productData = mkDefault "${pkgs.fprot}/opt/f-prot/product.data";
    services.fprot.updater.licenseKeyfile = mkDefault "${pkgs.fprot}/opt/f-prot/license.key";

    environment.systemPackages = [ pkgs.fprot ];
    environment.etc."f-prot.conf" = {
      source = "${pkgs.fprot}/opt/f-prot/f-prot.conf";
    };

    users.users.${fprotUser} =
      { uid = config.ids.uids.fprot;
        description = "F-Prot daemon user";
        home = stateDir;
      };

    users.groups.${fprotGroup} =
      { gid = config.ids.gids.fprot; };

    services.cron.systemCronJobs = [ "*/${toString cfg.updater.frequency} * * * * root start fprot-updater" ];

    systemd.services.fprot-updater = {
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = false;
      };
      wantedBy = [ "multi-user.target" ];

      # have to copy fpupdate executable because it insists on storing the virus database in the same dir
      preStart = ''
        mkdir -m 0755 -p ${stateDir}
        chown ${fprotUser}:${fprotGroup} ${stateDir}
        cp ${pkgs.fprot}/opt/f-prot/fpupdate ${stateDir}
        ln -sf ${cfg.updater.productData} ${stateDir}/product.data
      '';

      script = "/var/lib/fprot/fpupdate --keyfile ${cfg.updater.licenseKeyfile}";
    };
 };
}

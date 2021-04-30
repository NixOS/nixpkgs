{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) enum;
  cfg = config.services.afterburn;
  needsCheckin = provider: provider == "azure";
  needsFirstBootCheckin = provider: provider == "packet";
in
{
  options = {
    services.afterburn = {
      enable = mkEnableOption "afterburn";
      provider = mkOption {
        description = ''
          Sets ignition.platform.id=$provider on the kernel commandline.
        '';
        # TODO: can this also be null, and left to the user to set?
        type = enum [
          "aliyun"
          "aws"
          "azure"
          "cloudstack-configdrive"
          "cloudstack-metadata"
          "digitalocean"
          "exoscale"
          "gcp"
          "ibmcloud"
          "ibmcloud-classic"
          "openstack"
          "openstack-metadata"
          "packet"
          "vultr"
        ];
      };
      # TODO: make ssh pubkeys configurable?
      # TODO: enable and make network units configurable?
      # TODO: check nixos/modules/virtualisation/{brightbox-image,digital-ocean-config,ec2-metadata-fetcher}.nix
    };
  };
  config = mkIf cfg.enable {
    boot.kernelParams = mkIf (cfg.provider != null) [ "ignition.platform.id=${cfg.provider}" ];
    systemd = {
      # As of now, afterburn provides the following units.
      # Most of them are conditional on ignition.platform.id being passed in the command line,
      # so they can be added to multi-user.target unconditionally.
      # - afterburn-{firstboot-}checkin.service:
      #   Only applies for azure/packet (as of now).
      #   Tells the provider the machine booted up successfully.
      #   For afterburn-firstboot-checkin, we also need ConditionFirstBoot= to work.
      # - afterburn.service:
      #   Populates a EnvironmentFile at /run/metadata/afterburn.
      #   Meant to be pulled in by other units that want to read from there.
      # - afterburn-sshkeys@.service:
      #   Template unit. Distro needs to enable a afterburn-sshkeys@$username.
      #   We might want to expose the list of users in a config option.
      #   Needs a fix for #80933, possible fix at #115549.
      #   Has Install.DefaultInstance=root, and Install.RequiredBy=afterburn-sshkeys.target,
      #   needs to be verified to work as expected on NixOS.
      # - afterburn-sshkeys.target:
      #   Syncronizes afterburn-sshkeys@.service units, has a Install.RequiredBy=multi-user.target.
      #   ^ To my understanding, this means that afterburn-sshkeys@.service is implicitly always enabled
      #   Certainly needs some testing on our side.

      packages = [ pkgs.afterburn ];
      # Workaround for the fact that ConditionFirstBoot= doesn't work in NixOS currently.
      # TODO(arianvp): Verify this is really broken, provide a VM test repro.
      # #77607 might suggest it should work.
      services."afterburn-firstboot-checkin" = {
        unitConfig.ConditionPathExists = "!/var/lib/afterburn-firstboot-checkin/completed";
        serviceConfig = {
          StateDirectory = "afterburn-firstboot-checkin";
          ExecStartPost = "${pkgs.coreutils}/bin/touch /var/lib/afterburn-firstboot-checkin/completed";
        };
      };
      services."afterburn-sshkeys@root".enable = true;
    };
    services.openssh.authorizedKeysFiles = [ ".ssh/authorized_keys.d/afterburn" ];
  };
}

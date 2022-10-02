{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.davfs2;
  cfgFile = pkgs.writeText "davfs2.conf" ''
    dav_user ${cfg.davUser}
    dav_group ${cfg.davGroup}
    ${cfg.extraConfig}
  '';
in
{
  options.services.davfs2 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable davfs2.
      '';
    };

    davUser = mkOption {
      type = types.str;
      default = "davfs2";
      description = lib.mdDoc ''
        When invoked by root the mount.davfs daemon will run as this user.
        Value must be given as name, not as numerical id.
      '';
    };

    davGroup = mkOption {
      type = types.str;
      default = "davfs2";
      description = lib.mdDoc ''
        The group of the running mount.davfs daemon. Ordinary users must be
        member of this group in order to mount a davfs2 file system. Value must
        be given as name, not as numerical id.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        kernel_fs coda
        proxy foo.bar:8080
        use_locks 0
      '';
      description = lib.mdDoc ''
        Extra lines appended to the configuration of davfs2.
      ''  ;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.davfs2 ];
    environment.etc."davfs2/davfs2.conf".source = cfgFile;

    users.groups = optionalAttrs (cfg.davGroup == "davfs2") {
      davfs2.gid = config.ids.gids.davfs2;
    };

    users.users = optionalAttrs (cfg.davUser == "davfs2") {
      davfs2 = {
        createHome = false;
        group = cfg.davGroup;
        uid = config.ids.uids.davfs2;
        description = "davfs2 user";
      };
    };

    security.wrappers."mount.davfs" = {
      program = "mount.davfs";
      source = "${pkgs.davfs2}/bin/mount.davfs";
      owner = "root";
      group = cfg.davGroup;
      setuid = true;
      permissions = "u+rx,g+x";
    };

    security.wrappers."umount.davfs" = {
      program = "umount.davfs";
      source = "${pkgs.davfs2}/bin/umount.davfs";
      owner = "root";
      group = cfg.davGroup;
      setuid = true;
      permissions = "u+rx,g+x";
    };

  };

}

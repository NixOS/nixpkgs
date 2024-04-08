{ config, lib, pkgs, ... }:

with lib;

let
  toStr = value:
    if true == value then "yes"
    else if false == value then "no"
    else toString value;

  cfg = config.services.davfs2;
  format = pkgs.formats.toml { };
  configFile = let
    settings = mapAttrsToList (n: v: "${n} = ${toStr v}") cfg.settings;
  in pkgs.writeText "davfs2.conf" ''
    ${concatStringsSep "\n" settings}
    ${cfg.extraConfig}
  '';
in
{

  options.services.davfs2 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable davfs2.
      '';
    };

    davUser = mkOption {
      type = types.str;
      default = "davfs2";
      description = ''
        When invoked by root the mount.davfs daemon will run as this user.
        Value must be given as name, not as numerical id.
      '';
    };

    davGroup = mkOption {
      type = types.str;
      default = "davfs2";
      description = ''
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
      description = ''
        Extra lines appended to the configuration of davfs2.
        See {manpage}`davfs2.conf(5)` for available settings.

        **Note**: Please pass structured settings via
        {option}`settings` instead, this option
        will get deprecated in the future.
      ''  ;
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
      };
      default = {};
      example = literalExpression ''
        {
          kernel_fs = "coda";
          proxy = "foo.bar:8080";
          use_locks = 0;
        }
      '';
      description = ''
        Extra settings appended to the configuration of davfs2.
        See {manpage}`davfs2.conf(5)` for available settings.
      ''  ;
    };
  };

  config = mkIf cfg.enable {

    warnings = lib.optional (cfg.extraConfig != "") ''
      services.davfs2.extraConfig will be deprecated in future releases;
      please use services.davfs2.settings instead.
    '';

    environment.systemPackages = [ pkgs.davfs2 ];
    environment.etc."davfs2/davfs2.conf".source = configFile;

    services.davfs2.settings = {
      dav_user = cfg.davUser;
      dav_group = cfg.davGroup;
    };

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

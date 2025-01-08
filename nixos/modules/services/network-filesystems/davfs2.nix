{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.davfs2;

  escapeString = lib.escape [
    "\""
    "\\"
  ];

  formatValue =
    value:
    if true == value then
      "1"
    else if false == value then
      "0"
    else if builtins.isString value then
      "\"${escapeString value}\""
    else
      toString value;

  configFile = pkgs.writeText "davfs2.conf" (
    lib.generators.toINIWithGlobalSection {
      mkSectionName = escapeString;
      mkKeyValue = k: v: "${k} ${formatValue v}";
    } cfg.settings
  );
in
{

  imports = [
    (lib.mkRemovedOptionModule [ "services" "davfs2" "extraConfig" ] ''
      The option extraConfig got removed, please migrate to
      services.davfs2.settings instead.
    '')
  ];

  options.services.davfs2 = {
    enable = lib.mkEnableOption "davfs2";

    davUser = lib.mkOption {
      type = lib.types.str;
      default = "davfs2";
      description = ''
        When invoked by root the mount.davfs daemon will run as this user.
        Value must be given as name, not as numerical id.
      '';
    };

    davGroup = lib.mkOption {
      type = lib.types.str;
      default = "davfs2";
      description = ''
        The group of the running mount.davfs daemon. Ordinary users must be
        member of this group in order to mount a davfs2 file system. Value must
        be given as name, not as numerical id.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          let
            valueTypes = [
              lib.types.bool
              lib.types.int
              lib.types.str
            ];
          in
          lib.types.attrsOf (lib.types.attrsOf (lib.types.oneOf (valueTypes ++ [ (lib.types.attrsOf (lib.types.oneOf valueTypes)) ])));
      };
      default = { };
      example = lib.literalExpression ''
        {
          globalSection = {
            proxy = "foo.bar:8080";
            use_locks = false;
          };
          sections = {
            "/media/dav" = {
              use_locks = true;
            };
            "/home/otto/mywebspace" = {
              gui_optimize = true;
            };
          };
        }
      '';
      description = ''
        Extra settings appended to the configuration of davfs2.
        See {manpage}`davfs2.conf(5)` for available settings.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.davfs2 ];
    environment.etc."davfs2/davfs2.conf".source = configFile;

    services.davfs2.settings = {
      globalSection = {
        dav_user = cfg.davUser;
        dav_group = cfg.davGroup;
      };
    };

    users.groups = lib.optionalAttrs (cfg.davGroup == "davfs2") {
      davfs2.gid = config.ids.gids.davfs2;
    };

    users.users = lib.optionalAttrs (cfg.davUser == "davfs2") {
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

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.generators) toINIWithGlobalSection;
  inherit (lib.lists) optional;
  inherit (lib.modules) mkIf;
  inherit (lib.options) literalExpression mkEnableOption mkOption;
  inherit (lib.strings) escape;
  inherit (lib.types)
    attrsOf
    bool
    int
    lines
    oneOf
    str
    submodule
    ;

  cfg = config.services.davfs2;

  escapeString = escape [
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
    if (cfg.settings != { }) then
      (toINIWithGlobalSection {
        mkSectionName = escapeString;
        mkKeyValue = k: v: "${k} ${formatValue v}";
      } cfg.settings)
    else
      cfg.extraConfig
  );
in
{

  options.services.davfs2 = {
    enable = mkEnableOption "davfs2";

    davUser = mkOption {
      type = str;
      default = "davfs2";
      description = ''
        When invoked by root the mount.davfs daemon will run as this user.
        Value must be given as name, not as numerical id.
      '';
    };

    davGroup = mkOption {
      type = str;
      default = "davfs2";
      description = ''
        The group of the running mount.davfs daemon. Ordinary users must be
        member of this group in order to mount a davfs2 file system. Value must
        be given as name, not as numerical id.
      '';
    };

    extraConfig = mkOption {
      type = lines;
      default = "";
      example = ''
        proxy foo.bar:8080
        use_locks 0

        [/media/dav]
        use_locks 1

        [/home/otto/mywebspace]
        gui_optimize 1
      '';
      description = ''
        Extra lines appended to the configuration of davfs2.
        See {manpage}`davfs2.conf(5)` for available settings.

        **Note**: Please pass structured settings via
        {option}`settings` instead, this option
        will get deprecated in the future.
      '';
    };

    settings = mkOption {
      type = submodule {
        freeformType =
          let
            valueTypes = [
              bool
              int
              str
            ];
          in
          attrsOf (attrsOf (oneOf (valueTypes ++ [ (attrsOf (oneOf valueTypes)) ])));
      };
      default = { };
      example = literalExpression ''
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

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.extraConfig != "" -> cfg.settings == { };
        message = ''
          services.davfs2.extraConfig and services.davfs2.settings cannot be used together.
          Please prefer using services.davfs2.settings.
        '';
      }
    ];

    warnings = optional (cfg.extraConfig != "") ''
      services.davfs2.extraConfig will be deprecated in future releases;
      please use services.davfs2.settings instead.
    '';

    environment.systemPackages = [ pkgs.davfs2 ];
    environment.etc."davfs2/davfs2.conf".source = configFile;

    services.davfs2.settings = {
      globalSection = {
        dav_user = cfg.davUser;
        dav_group = cfg.davGroup;
      };
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

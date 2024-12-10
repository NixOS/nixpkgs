{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  cfg = config.programs.benchexec;
  opt = options.programs.benchexec;

  filterUsers =
    x:
    if builtins.isString x then
      config.users.users ? ${x}
    else if builtins.isInt x then
      x
    else
      throw "filterUsers expects string (username) or int (UID)";

  uid =
    x:
    if builtins.isString x then
      config.users.users.${x}.uid
    else if builtins.isInt x then
      x
    else
      throw "uid expects string (username) or int (UID)";
in
{
  options.programs.benchexec = {
    enable = lib.mkEnableOption "BenchExec";
    package = lib.options.mkPackageOption pkgs "benchexec" { };

    users = lib.options.mkOption {
      type = with lib.types; listOf (either str int);
      description = ''
        Users that intend to use BenchExec.
        Provide usernames of users that are configured via {option}`${options.users.users}` as string,
        and UIDs of "mutable users" as integers.
        Control group delegation will be configured via systemd.
        For more information, see <https://github.com/sosy-lab/benchexec/blob/3.18/doc/INSTALL.md#setting-up-cgroups>.
      '';
      default = [ ];
      example = lib.literalExpression ''
        [
          "alice" # username of a user configured via ${options.users.users}
          1007    # UID of a mutable user
        ]
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      (map (user: {
        assertion = config.users.users ? ${user};
        message = ''
          The user '${user}' intends to use BenchExec (via `${opt.users}`), but is not configured via `${options.users.users}`.
        '';
      }) (builtins.filter builtins.isString cfg.users))
      ++ (map (id: {
        assertion = config.users.mutableUsers;
        message = ''
          The user with UID '${id}' intends to use BenchExec (via `${opt.users}`), but mutable users are disabled via `${options.users.mutableUsers}`.
        '';
      }) (builtins.filter builtins.isInt cfg.users))
      ++ [
        {
          assertion = config.systemd.enableUnifiedCgroupHierarchy == true;
          message = ''
            The BenchExec module `${opt.enable}` only supports control groups 2 (`${options.systemd.enableUnifiedCgroupHierarchy} = true`).
          '';
        }
      ];

    environment.systemPackages = [ cfg.package ];

    # See <https://github.com/sosy-lab/benchexec/blob/3.18/doc/INSTALL.md#setting-up-cgroups>.
    systemd.services = builtins.listToAttrs (
      map (user: {
        name = "user@${builtins.toString (uid user)}";
        value = {
          serviceConfig.Delegate = "yes";
          overrideStrategy = "asDropin";
        };
      }) (builtins.filter filterUsers cfg.users)
    );

    # See <https://github.com/sosy-lab/benchexec/blob/3.18/doc/INSTALL.md#requirements>.
    virtualisation.lxc.lxcfs.enable = lib.mkDefault true;

    # See <https://github.com/sosy-lab/benchexec/blob/3.18/doc/INSTALL.md#requirements>.
    programs = {
      cpu-energy-meter.enable = lib.mkDefault true;
      pqos-wrapper.enable = lib.mkDefault true;
    };

    # See <https://github.com/sosy-lab/benchexec/blob/3.18/doc/INSTALL.md#kernel-requirements>.
    security.unprivilegedUsernsClone = true;
  };

  meta.maintainers = with lib.maintainers; [ lorenzleutgeb ];
}

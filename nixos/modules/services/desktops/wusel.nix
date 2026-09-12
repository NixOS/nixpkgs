{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.wusel;
in
{
  meta.maintainers = with lib.maintainers; [ ser ];

  options.services.wusel = {
    enable = lib.mkEnableOption "Wusel — virtual Nextcloud filesystem (user services)";
    package = lib.mkPackageOption pkgs "wusel" { };
    accounts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "default" ];
      example = lib.literalExpression ''[ "default" "work" ]'';
      description = ''
        Account names to mount a Wusel instance for. Each becomes one
        `wusel-<name>.service` unit under the user manager, identical in
        shape to the upstream `wusel@<name>.service` template. The account
        must exist in `wusel accounts` (typically created with
        `wusel login --account <name> https://cloud.example.org`) before
        the unit will mount successfully.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # One user-service instance per entry in `accounts`. Mirrors the
    # upstream `wusel@<account>.service` template: `mount --account %i`,
    # `Restart=on-failure`, `WantedBy=default.target` — and the same
    # caveat about no sandboxing directives (fusermount3 needs setuid).
    systemd.user.services =
      let
        mkInstance = account: {
          name = "wusel-${account}";
          value = {
            description = "Wusel — virtual Nextcloud filesystem (${account})";
            wantedBy = [ "default.target" ];
            serviceConfig = {
              ExecStart = "${lib.getExe cfg.package} mount --account ${account}";
              Restart = "on-failure";
              RestartSec = "5";
            };
          };
        };
      in
      lib.listToAttrs (map mkInstance cfg.accounts);
  };
}
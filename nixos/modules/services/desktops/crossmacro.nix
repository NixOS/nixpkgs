{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.crossmacro;
in
{
  options.services.crossmacro = {
    enable = lib.mkEnableOption "CrossMacro, a cross-platform mouse and keyboard macro application";

    package = lib.mkPackageOption pkgs "crossmacro" { };

    daemonPackage = lib.mkPackageOption pkgs "crossmacro-daemon" { };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "alice"
        "bob"
      ];
      description = "List of users granted permission to use CrossMacro.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.users != [ ];
        message = "CrossMacro: You must specify at least one user. Set `services.crossmacro.users`.";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    hardware.uinput.enable = true;

    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
      ACTION=="add|change", KERNEL=="event*", ATTRS{name}=="CrossMacro Virtual Input Device", ENV{LIBINPUT_ATTR_POINTER_ACCEL}="0"
    '';

    environment.etc."polkit-1/actions/org.crossmacro.policy".source =
      "${cfg.daemonPackage}/share/polkit-1/actions/org.crossmacro.policy";

    environment.etc."polkit-1/rules.d/50-crossmacro.rules".source =
      "${cfg.daemonPackage}/share/polkit-1/rules.d/50-crossmacro.rules";

    users.groups.crossmacro = { };

    users.users =
      lib.listToAttrs (
        map (user: {
          name = user;
          value = {
            extraGroups = [ "crossmacro" ];
          };
        }) cfg.users
      )
      // {
        crossmacro = {
          isSystemUser = true;
          group = "input";
          extraGroups = [
            "crossmacro"
            "uinput"
          ];
          description = "CrossMacro Input Daemon User";
        };
      };

    systemd.services.crossmacro = {
      description = "CrossMacro Input Daemon Service";
      documentation = [ "https://github.com/alper-han/CrossMacro" ];

      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "dbus.service"
        "polkit.service"
      ];
      wants = [
        "dbus.service"
        "polkit.service"
      ];

      path = [ pkgs.polkit ];

      serviceConfig = {
        Type = "notify";
        User = "crossmacro";
        Group = "input";
        ExecStart = lib.getExe cfg.daemonPackage;
        Restart = "always";
        RestartSec = 5;
        RuntimeDirectory = "crossmacro";
        RuntimeDirectoryMode = "0755";
        CapabilityBoundingSet = [
          "CAP_SYS_ADMIN"
          "CAP_SETUID"
          "CAP_SETGID"
          "CAP_CHOWN"
          "CAP_DAC_READ_SEARCH"
        ];
        AmbientCapabilities = [
          "CAP_SYS_ADMIN"
          "CAP_CHOWN"
          "CAP_DAC_READ_SEARCH"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ alper-han ];
}

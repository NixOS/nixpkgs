{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  format = pkgs.formats.yaml { };
  cfg = config.services.evdevremapkeys;

in
{
  options.services.evdevremapkeys = {
    enable = mkEnableOption ''evdevremapkeys, a daemon to remap events on linux input devices'';

    settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        config.yaml for evdevremapkeys
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "uinput" ];
    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="input"
    '';
    users.groups.evdevremapkeys = { };
    users.users.evdevremapkeys = {
      description = "evdevremapkeys service user";
      group = "evdevremapkeys";
      extraGroups = [ "input" ];
      isSystemUser = true;
    };
    systemd.services.evdevremapkeys = {
      description = "evdevremapkeys";
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
        let
          config = format.generate "config.yaml" cfg.settings;
        in
        {
          ExecStart = "${pkgs.evdevremapkeys}/bin/evdevremapkeys --config-file ${config}";
          User = "evdevremapkeys";
          Group = "evdevremapkeys";
          StateDirectory = "evdevremapkeys";
          Restart = "always";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateNetwork = true;
          PrivateTmp = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectSystem = true;
        };
    };
  };
}

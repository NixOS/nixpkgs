{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kloak;
in
{
  options.services.kloak = {
    enable = lib.mkEnableOption "kloak, a keystroke-level online anonymization kernel";

    package = lib.mkPackageOption pkgs "kloak" { };

    extraArgs = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = lib.literalExpression ''
        [
          "--delay"
          "100"
          "--start-delay"
          "500"
        ]
      '';
      description = ''
        Extra arguments passed to the kloak daemon.
        Available options include:
        - --delay: Maximum delay of released events in milliseconds (default: 100)
        - --start-delay: Time to wait before startup in milliseconds (default: 500)
        - --color: Virtual mouse cursor color in AARRGGBB format (default: ffff0000)
        - --natural-scrolling: Enable natural scrolling (true|false, default: false)
        - --esc-key-combo: Key combination to terminate kloak (default: KEY_RIGHTSHIFT,KEY_ESC)

        See kloak --help for more details.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.kloak = {
      description = "Kloak Keystroke-Level Online Anonymization Kernel";
      documentation = [ "https://github.com/Whonix/kloak" ];
      after = [ "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.escapeShellArgs ([ "${lib.getExe cfg.package}" ] ++ cfg.extraArgs);
        Restart = "on-failure";
        RestartSec = 2;

        # Security hardening
        User = "root";
        CapabilityBoundingSet = [
          "CAP_SYS_ADMIN"
          "CAP_SYS_RAWIO"
        ];
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
      };
    };
  };
}

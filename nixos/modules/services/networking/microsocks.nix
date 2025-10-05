{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.microsocks;

  cmd =
    if cfg.execWrapper != null then
      "${cfg.execWrapper} ${cfg.package}/bin/microsocks"
    else
      "${cfg.package}/bin/microsocks";
  args = [
    "-i"
    cfg.ip
    "-p"
    (toString cfg.port)
  ]
  ++ lib.optionals (cfg.authOnce) [ "-1" ]
  ++ lib.optionals (cfg.disableLogging) [ "-q" ]
  ++ lib.optionals (cfg.outgoingBindIp != null) [
    "-b"
    cfg.outgoingBindIp
  ]
  ++ lib.optionals (cfg.authUsername != null) [
    "-u"
    cfg.authUsername
  ];
in
{
  options.services.microsocks = {
    enable = lib.mkEnableOption "Tiny, portable SOCKS5 server with very moderate resource usage";
    user = lib.mkOption {
      default = "microsocks";
      description = "User microsocks runs as.";
      type = lib.types.str;
    };
    group = lib.mkOption {
      default = "microsocks";
      description = "Group microsocks runs as.";
      type = lib.types.str;
    };
    package = lib.mkPackageOption pkgs "microsocks" { };
    ip = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = ''
        IP on which microsocks should listen. Defaults to 127.0.0.1 for
        security reasons.
      '';
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 1080;
      description = "Port on which microsocks should listen.";
    };
    disableLogging = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If true, microsocks will not log any messages to stdout/stderr.";
    };
    authOnce = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If true, once a specific ip address authed successfully with user/pass,
        it is added to a whitelist and may use the proxy without auth.
      '';
    };
    outgoingBindIp = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Specifies which ip outgoing connections are bound to";
    };
    authUsername = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "alice";
      description = "Optional username to use for authentication.";
    };
    authPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/microsocks-password";
      description = "Path to a file containing the password for authentication.";
    };
    execWrapper = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = ''
        ''${pkgs.mullvad-vpn}/bin/mullvad-exclude
      '';
      description = ''
        An optional command to prepend to the microsocks command (such as proxychains, or a VPN exclude command).
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.authUsername != null) == (cfg.authPasswordFile != null);
        message = "Need to set both authUsername and authPasswordFile for microsocks";
      }
    ];
    users = {
      users = lib.mkIf (cfg.user == "microsocks") {
        microsocks = {
          group = cfg.group;
          isSystemUser = true;
        };
      };
      groups = lib.mkIf (cfg.group == "microsocks") {
        microsocks = { };
      };
    };
    systemd.services.microsocks = {
      enable = true;
      description = "a tiny socks server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = 10;
        LoadCredential = lib.optionalString (
          cfg.authPasswordFile != null
        ) "MICROSOCKS_PASSWORD_FILE:${cfg.authPasswordFile}";
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        PrivateTmp = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateDevices = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = [
          "cgroup"
          "ipc"
          "pid"
          "user"
          "uts"
        ];
      };
      script =
        if cfg.authPasswordFile != null then
          ''
            PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/MICROSOCKS_PASSWORD_FILE")
            ${cmd} ${lib.escapeShellArgs args} -P "$PASSWORD"
          ''
        else
          ''
            ${cmd} ${lib.escapeShellArgs args}
          '';
    };
  };
}

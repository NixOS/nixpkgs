{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.scion.scion-dispatcher;
  toml = pkgs.formats.toml { };
  defaultConfig = {
    dispatcher = {
      id = "dispatcher";
      socket_file_mode = "0770";
      application_socket = "/dev/shm/dispatcher/default.sock";
    };
    log.console = {
      level = "info";
    };
  };
  configFile = toml.generate "scion-dispatcher.toml" (defaultConfig // cfg.settings);
in
{
  options.services.scion.scion-dispatcher = {
    enable = mkEnableOption "the scion-dispatcher service";
    settings = mkOption {
      default = { };
      type = toml.type;
      example = literalExpression ''
        {
          dispatcher = {
            id = "dispatcher";
            socket_file_mode = "0770";
            application_socket = "/dev/shm/dispatcher/default.sock";
          };
          log.console = {
            level = "info";
          };
        }
      '';
      description = ''
        scion-dispatcher configuration. Refer to
        <https://docs.scion.org/en/latest/manuals/common.html>
        for details on supported values.
      '';
    };
  };
  config = mkIf cfg.enable {
    # Needed for group ownership of the dispatcher socket
    users.groups.scion = { };

    # scion programs hardcode path to dispatcher in /run/shm, and is not
    # configurable at runtime upstream plans to obsolete the dispatcher in
    # favor of an SCMP daemon, at which point this can be removed.
    system.activationScripts.scion-dispatcher = ''
      ln -sf /dev/shm /run/shm
    '';

    systemd.services.scion-dispatcher = {
      description = "SCION Dispatcher";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        Group = "scion";
        DynamicUser = true;
        BindPaths = [ "/dev/shm:/run/shm" ];
        ExecStartPre = "${pkgs.coreutils}/bin/rm -rf /run/shm/dispatcher";
        ExecStart = "${pkgs.scion}/bin/scion-dispatcher --config ${configFile}";
        Restart = "on-failure";
        StateDirectory = "scion-dispatcher";
      };
    };
  };
}

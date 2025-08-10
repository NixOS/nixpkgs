{ config, lib, ... }:

let
  cfg = config.services.userdbd;
in
{
  options.services.userdbd = {
    enable = lib.mkEnableOption ''
      the systemd JSON user/group record lookup service
    '';

    enableSSHSupport = lib.mkEnableOption ''
      exposing OpenSSH public keys defined in userdb. Be aware that this
      enables modifying public keys at runtime, either by users managed by
      {option}`services.homed`, or globally via drop-in files
    '';
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.singleton {
      assertion = cfg.enableSSHSupport -> config.security.enableWrappers;
      message = "OpenSSH userdb integration requires security wrappers.";
    };

    systemd.additionalUpstreamSystemUnits = [
      "systemd-userdbd.socket"
      "systemd-userdbd.service"
    ];

    systemd.sockets.systemd-userdbd.wantedBy = [ "sockets.target" ];

    # OpenSSH requires AuthorizedKeysCommand to be owned only by root.
    # Referencing `userdbctl` directly from the Nix store won't work, as
    # `/nix/store` is owned by the `nixbld` group.
    security.wrappers = lib.mkIf cfg.enableSSHSupport {
      userdbctl = {
        owner = "root";
        group = "root";
        source = lib.getExe' config.systemd.package "userdbctl";
      };
    };

    services.openssh = lib.mkIf cfg.enableSSHSupport {
      authorizedKeysCommand = "/run/wrappers/bin/userdbctl ssh-authorized-keys %u";
      authorizedKeysCommandUser = "root";
    };
  };
}

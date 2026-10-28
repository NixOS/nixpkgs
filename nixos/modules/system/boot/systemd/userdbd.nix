{ config, lib, ... }:

let
  cfg = config.services.userdbd;

  # List of system users that will be incorrectly treated as regular/normal
  # users by userdb.
  highSystemUsers = lib.filter (
    user: user.enable && user.isSystemUser && (lib.defaultTo 0 user.uid) >= 1000 && user.uid != 65534
  ) (lib.attrValues config.users.users);
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

    silenceHighSystemUsers = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Silence warning about system users with high UIDs.";
      visible = false;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.singleton {
      assertion = cfg.enableSSHSupport -> config.security.enableWrappers;
      message = "OpenSSH userdb integration requires security wrappers.";
    };

    warnings = lib.optional (lib.length highSystemUsers > 0 && !cfg.silenceHighSystemUsers) ''
      The following system users have UIDs higher than 1000:

      ${lib.concatLines (lib.map (user: user.name) highSystemUsers)}

      These users will be recognized by systemd-userdb as "regular" users, not
      "system" users. This will affect programs that query regular users, such
      as systemd-homed, which will not run the first boot user creation flow,
      as regular users already exist.

      To fix this issue, please remove or redefine these system users to have
      UIDs below 1000. For Nix build users, it's possible to adjust the base
      build user ID using the `ids.uids.nixbld` option, however care must be
      taken to avoid collisions with UIDs of other services. Alternatively, you
      may enable the `auto-allocate-uids` experimental feature and option in
      the Nix configuration to avoid creating these users, however please note
      that this option is experimental and subject to change.

      Alternatively, to acknowledge and silence this warning, set
      `services.userdbd.silenceHighSystemUsers` to true.
    '';

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

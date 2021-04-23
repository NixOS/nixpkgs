{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.getty;

  baseArgs = [
    "--login-program" "${pkgs.shadow}/bin/login"
  ] ++ optionals (cfg.autologinUser != null) [
    "--autologin" cfg.autologinUser
  ] ++ optionals (cfg.loginOptions != null) [
    "--login-options" cfg.loginOptions
  ] ++ cfg.extraArgs;

  gettyCmd = args:
    "@${pkgs.util-linux}/sbin/agetty agetty ${escapeShellArgs baseArgs} ${args}";

in

{

  ###### interface

  imports = [
    (mkRenamedOptionModule [ "services" "mingetty" ] [ "services" "getty" ])
  ];

  options = {

    services.getty = {

      autologinUser = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Username of the account that will be automatically logged in at the console.
          If unspecified, a login prompt is shown as usual.
        '';
      };

      loginOptions = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Template for arguments to be passed to
          <citerefentry><refentrytitle>login</refentrytitle>
          <manvolnum>1</manvolnum></citerefentry>.

          See <citerefentry><refentrytitle>agetty</refentrytitle>
          <manvolnum>1</manvolnum></citerefentry> for details,
          including security considerations.  If unspecified, agetty
          will not be invoked with a <option>--login-options</option>
          option.
        '';
        example = "-h darkstar -- \\u";
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Additional arguments passed to agetty.
        '';
        example = [ "--nohostname" ];
      };

      greetingLine = mkOption {
        type = types.str;
        description = ''
          Welcome line printed by agetty.
          The default shows current NixOS version label, machine type and tty.
        '';
      };

      helpLine = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Help line printed by agetty below the welcome line.
          Used by the installation CD to give some hints on
          how to proceed.
        '';
      };

      serialSpeed = mkOption {
        type = types.listOf types.int;
        default = [ 115200 57600 38400 9600 ];
        example = [ 38400 9600 ];
        description = ''
            Bitrates to allow for agetty's listening on serial ports. Listing more
            bitrates gives more interoperability but at the cost of long delays
            for getting a sync on the line.
        '';
      };

    };

  };


  ###### implementation

  config = {
    # Note: this is set here rather than up there so that changing
    # nixos.label would not rebuild manual pages
    services.getty.greetingLine = mkDefault ''<<< Welcome to NixOS ${config.system.nixos.label} (\m) - \l >>>'';

    systemd.services."getty@" =
      { serviceConfig.ExecStart = [
          "" # override upstream default with an empty ExecStart
          (gettyCmd "--noclear --keep-baud %I 115200,38400,9600 $TERM")
        ];
        restartIfChanged = false;
      };

    systemd.services."serial-getty@" =
      let speeds = concatStringsSep "," (map toString config.services.getty.serialSpeed); in
      { serviceConfig.ExecStart = [
          "" # override upstream default with an empty ExecStart
          (gettyCmd "%I ${speeds} $TERM")
        ];
        restartIfChanged = false;
      };

    systemd.services."container-getty@" =
      { serviceConfig.ExecStart = [
          "" # override upstream default with an empty ExecStart
          (gettyCmd "--noclear --keep-baud pts/%I 115200,38400,9600 $TERM")
        ];
        restartIfChanged = false;
      };

    systemd.services.console-getty =
      { serviceConfig.ExecStart = [
          "" # override upstream default with an empty ExecStart
          (gettyCmd "--noclear --keep-baud console 115200,38400,9600 $TERM")
        ];
        serviceConfig.Restart = "always";
        restartIfChanged = false;
        enable = mkDefault config.boot.isContainer;
      };

    environment.etc.issue =
      { # Friendly greeting on the virtual consoles.
        source = pkgs.writeText "issue" ''

          [1;32m${config.services.getty.greetingLine}[0m
          ${config.services.getty.helpLine}

        '';
      };

  };

}

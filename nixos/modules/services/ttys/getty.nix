{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.getty;

  baseArgs = [
    "--login-program" "${cfg.loginProgram}"
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
    (mkRemovedOptionModule [ "services" "getty" "serialSpeed" ] ''set non-standard baudrates with `boot.kernelParams` i.e. boot.kernelParams = ["console=ttyS2,1500000"];'')
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

      loginProgram = mkOption {
        type = types.path;
        default = "${pkgs.shadow}/bin/login";
        defaultText = literalExpression ''"''${pkgs.shadow}/bin/login"'';
        description = ''
          Path to the login binary executed by agetty.
        '';
      };

      loginOptions = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Template for arguments to be passed to
          {manpage}`login(1)`.

          See {manpage}`agetty(1)` for details,
          including security considerations.  If unspecified, agetty
          will not be invoked with a {option}`--login-options`
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

    };

  };


  ###### implementation

  config = {
    # Note: this is set here rather than up there so that changing
    # nixos.label would not rebuild manual pages
    services.getty.greetingLine = mkDefault ''<<< Welcome to NixOS ${config.system.nixos.label} (\m) - \l >>>'';
    services.getty.helpLine = mkIf (config.documentation.nixos.enable && config.documentation.doc.enable) "\nRun 'nixos-help' for the NixOS manual.";

    systemd.services."getty@" =
      { serviceConfig.ExecStart = [
          "" # override upstream default with an empty ExecStart
          (gettyCmd "--noclear --keep-baud %I 115200,38400,9600 $TERM")
        ];
        restartIfChanged = false;
      };

    systemd.services."serial-getty@" =
      { serviceConfig.ExecStart = [
          "" # override upstream default with an empty ExecStart
          (gettyCmd "%I --keep-baud $TERM")
        ];
        restartIfChanged = false;
      };

    systemd.services."autovt@" =
      { serviceConfig.ExecStart = [
          "" # override upstream default with an empty ExecStart
          (gettyCmd "--noclear %I $TERM")
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

    environment.etc.issue = mkDefault
      { # Friendly greeting on the virtual consoles.
        source = pkgs.writeText "issue" ''

          [1;32m${config.services.getty.greetingLine}[0m
          ${config.services.getty.helpLine}

        '';
      };

  };

}

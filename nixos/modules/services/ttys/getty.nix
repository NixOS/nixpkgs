{ config, lib, pkgs, ... }:
let
  cfg = config.services.getty;

  baseArgs = [
    "--login-program" "${cfg.loginProgram}"
  ] ++ lib.optionals (cfg.autologinUser != null) [
    "--autologin" cfg.autologinUser
  ] ++ lib.optionals (cfg.loginOptions != null) [
    "--login-options" cfg.loginOptions
  ] ++ cfg.extraArgs;

  gettyCmd = args:
    "@${pkgs.util-linux}/sbin/agetty agetty ${lib.escapeShellArgs baseArgs} ${args}";

in

{

  ###### interface

  imports = [
    (lib.mkRenamedOptionModule [ "services" "mingetty" ] [ "services" "getty" ])
    (lib.mkRemovedOptionModule [ "services" "getty" "serialSpeed" ] ''set non-standard baudrates with `boot.kernelParams` i.e. boot.kernelParams = ["console=ttyS2,1500000"];'')
  ];

  options = {

    services.getty = {

      autologinUser = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Username of the account that will be automatically logged in at the console.
          If unspecified, a login prompt is shown as usual.
        '';
      };

      loginProgram = lib.mkOption {
        type = lib.types.path;
        default = "${pkgs.shadow}/bin/login";
        defaultText = lib.literalExpression ''"''${pkgs.shadow}/bin/login"'';
        description = ''
          Path to the login binary executed by agetty.
        '';
      };

      loginOptions = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
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

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Additional arguments passed to agetty.
        '';
        example = [ "--nohostname" ];
      };

      greetingLine = lib.mkOption {
        type = lib.types.str;
        description = ''
          Welcome line printed by agetty.
          The default shows current NixOS version label, machine type and tty.
        '';
      };

      helpLine = lib.mkOption {
        type = lib.types.lines;
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
    services.getty.greetingLine = lib.mkDefault ''<<< Welcome to ${config.system.nixos.distroName} ${config.system.nixos.label} (\m) - \l >>>'';
    services.getty.helpLine = lib.mkIf (config.documentation.nixos.enable && config.documentation.doc.enable) "\nRun 'nixos-help' for the NixOS manual.";

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
        enable = lib.mkDefault config.boot.isContainer;
      };

    environment.etc.issue = lib.mkDefault
      { # Friendly greeting on the virtual consoles.
        source = pkgs.writeText "issue" ''

          [1;32m${config.services.getty.greetingLine}[0m
          ${config.services.getty.helpLine}

        '';
      };

  };

  meta.maintainers = with lib.maintainers; [ RossComputerGuy ];
}

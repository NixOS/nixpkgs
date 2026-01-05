{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.pcscd;
  cfgFile = pkgs.writeText "reader.conf" (
    builtins.concatStringsSep "\n\n" config.services.pcscd.readerConfigs
  );

  package = if config.security.polkit.enable then pkgs.pcscliteWithPolkit else pkgs.pcsclite;

  pluginEnv = pkgs.buildEnv {
    name = "pcscd-plugins";
    paths = map (p: "${p}/pcsc/drivers") config.services.pcscd.plugins;
  };

in
{
  imports = [
    (lib.mkChangedOptionModule
      [ "services" "pcscd" "readerConfig" ]
      [ "services" "pcscd" "readerConfigs" ]
      (
        config:
        let
          readerConfig = lib.getAttrFromPath [ "services" "pcscd" "readerConfig" ] config;
        in
        [ readerConfig ]
      )
    )
  ];

  options.services.pcscd = {
    enable = lib.mkEnableOption "PCSC-Lite daemon, to access smart cards using SCard API (PC/SC)";

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      defaultText = lib.literalExpression "[ pkgs.ccid ]";
      example = lib.literalExpression "[ pkgs.pcsc-cyberjack ]";
      description = "Plugin packages to be used for PCSC-Lite.";
    };

    readerConfigs = lib.mkOption {
      type = lib.types.listOf lib.types.lines;
      default = [ ];
      example = [
        ''
          FRIENDLYNAME      "Some serial reader"
          DEVICENAME        /dev/ttyS0
          LIBPATH           /path/to/serial_reader.so
          CHANNELID         1
        ''
      ];
      description = ''
        Configuration for devices that aren't hotpluggable.

        See {manpage}`reader.conf(5)` for valid options.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra command line arguments to be passed to the PCSC daemon.";
    };

    ignoreReaderNames = lib.mkOption {
      type = lib.types.listOf (lib.types.strMatching "[^:]+");
      default = [ ];
      description = ''
        List of reader name patterns for the PCSC daemon to ignore.

        For more precise control, readers can be ignored through udev rules
        (cf. {option}`services.udev.extraRules`) by setting the
        `PCSCLITE_IGNORE` property, for example:

        ```
        ACTION!="remove|unbind", SUBSYSTEM=="usb", ATTR{idVendor}=="20a0", ENV{PCSCLITE_IGNORE}="1"
        ```
      '';
      example = [
        "Nitrokey"
        "YubiKey"
      ];
    };

    extendReaderNames = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        String to append to every reader name. The special variable `$HOSTNAME`
        will be expanded to the current host name.
      '';
      example = " $HOSTNAME";
    };
  };

  config = lib.mkIf config.services.pcscd.enable {
    environment.etc."reader.conf".source = cfgFile;

    environment.systemPackages = [ package ];
    systemd.packages = [ package ];

    services.pcscd.plugins = [ pkgs.ccid ];

    systemd.sockets.pcscd.wantedBy = [ "sockets.target" ];

    systemd.services.pcscd = {
      environment = {
        PCSCLITE_HP_DROPDIR = pluginEnv;

        PCSCLITE_FILTER_IGNORE_READER_NAMES = lib.mkIf (cfg.ignoreReaderNames != [ ]) (
          lib.concatStringsSep ":" cfg.ignoreReaderNames
        );

        PCSCLITE_FILTER_EXTEND_READER_NAMES = lib.mkIf (
          cfg.extendReaderNames != null
        ) cfg.extendReaderNames;
      };

      # If the cfgFile is empty and not specified (in which case the default
      # /etc/reader.conf is assumed), pcscd will happily start going through the
      # entire confdir (/etc in our case) looking for a config file and try to
      # parse everything it finds. Doesn't take a lot of imagination to see how
      # well that works. It really shouldn't do that to begin with, but to work
      # around it, we force the path to the cfgFile.
      #
      # https://github.com/NixOS/nixpkgs/issues/121088
      serviceConfig.ExecStart = [
        ""
        "${lib.getExe package} -f -x -c ${cfgFile} ${lib.escapeShellArgs cfg.extraArgs}"
      ];
    };
  };
}

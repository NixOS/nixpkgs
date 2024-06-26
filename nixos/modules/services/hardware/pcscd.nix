{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.pcscd;
  cfgFile = pkgs.writeText "reader.conf" config.services.pcscd.readerConfig;

  package = if config.security.polkit.enable then pkgs.pcscliteWithPolkit else pkgs.pcsclite;

  pluginEnv = pkgs.buildEnv {
    name = "pcscd-plugins";
    paths = map (p: "${p}/pcsc/drivers") config.services.pcscd.plugins;
  };

in
{
  options.services.pcscd = {
    enable = mkEnableOption "PCSC-Lite daemon, to access smart cards using SCard API (PC/SC)";

    plugins = mkOption {
      type = types.listOf types.package;
      defaultText = literalExpression "[ pkgs.ccid ]";
      example = literalExpression "[ pkgs.pcsc-cyberjack ]";
      description = "Plugin packages to be used for PCSC-Lite.";
    };

    readerConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        FRIENDLYNAME      "Some serial reader"
        DEVICENAME        /dev/ttyS0
        LIBPATH           /path/to/serial_reader.so
        CHANNELID         1
      '';
      description = ''
        Configuration for devices that aren't hotpluggable.

        See {manpage}`reader.conf(5)` for valid options.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra command line arguments to be passed to the PCSC daemon.";
    };
  };

  config = mkIf config.services.pcscd.enable {
    environment.etc."reader.conf".source = cfgFile;

    environment.systemPackages = [ package ];
    systemd.packages = [ package ];

    services.pcscd.plugins = [ pkgs.ccid ];

    systemd.sockets.pcscd.wantedBy = [ "sockets.target" ];

    systemd.services.pcscd = {
      environment.PCSCLITE_HP_DROPDIR = pluginEnv;

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

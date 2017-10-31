{ config, lib, pkgs, ... }:

with lib;

let
  cfgFile = pkgs.writeText "reader.conf" config.services.pcscd.readerConfig;

  pluginEnv = pkgs.buildEnv {
    name = "pcscd-plugins";
    paths = map (p: "${p}/pcsc/drivers") config.services.pcscd.plugins;
  };

in {

  ###### interface

  options = {

    services.pcscd = {
      enable = mkEnableOption "PCSC-Lite daemon";

      plugins = mkOption {
        type = types.listOf types.package;
        default = [ pkgs.ccid ];
        defaultText = "[ pkgs.ccid ]";
        example = literalExample "[ pkgs.pcsc-cyberjack ]";
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

          See <citerefentry><refentrytitle>reader.conf</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry> for valid options.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf config.services.pcscd.enable {

    systemd.sockets.pcscd = {
      description = "PCSC-Lite Socket";
      wantedBy = [ "sockets.target" ];
      before = [ "multi-user.target" ];
      socketConfig.ListenStream = "/run/pcscd/pcscd.comm";
    };

    systemd.services.pcscd = {
      description = "PCSC-Lite daemon";
      environment.PCSCLITE_HP_DROPDIR = pluginEnv;
      serviceConfig = {
        ExecStart = "${pkgs.pcsclite}/sbin/pcscd -f -x -c ${cfgFile}";
        ExecReload = "${pkgs.pcsclite}/sbin/pcscd -H";
      };
    };
  };
}

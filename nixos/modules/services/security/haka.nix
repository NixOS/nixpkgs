# This module defines global configuration for Haka.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.haka;

  haka = cfg.package;

  hakaConf = pkgs.writeText "haka.conf"
  ''
    [general]
    configuration = ${if lib.strings.hasPrefix "/" cfg.configFile
      then "${cfg.configFile}"
      else "${haka}/share/haka/sample/${cfg.configFile}"}
    ${optionalString (builtins.lessThan 0 cfg.threads) "thread = ${cfg.threads}"}

    [packet]
    ${optionalString cfg.pcap ''module = "packet/pcap"''}
    ${optionalString cfg.nfqueue ''module = "packet/nqueue"''}
    ${optionalString cfg.dump.enable ''dump = "yes"''}
    ${optionalString cfg.dump.enable ''dump_input = "${cfg.dump.input}"''}
    ${optionalString cfg.dump.enable ''dump_output = "${cfg.dump.output}"''}

    interfaces = "${lib.strings.concatStringsSep "," cfg.interfaces}"

    [log]
    # Select the log module
    module = "log/syslog"

    # Set the default logging level
    #level = "info,packet=debug"

    [alert]
    # Select the alert module
    module = "alert/syslog"

    # Disable alert on standard output
    #alert_on_stdout = no

    # alert/file module option
    #file = "/dev/null"
  '';

in

{

  ###### interface

  options = {

    services.haka = {

      enable = mkEnableOption "Haka";

      package = mkOption {
        default = pkgs.haka;
        defaultText = "pkgs.haka";
        type = types.package;
        description = "
          Which Haka derivation to use.
        ";
      };

      configFile = mkOption {
        default = "empty.lua";
        example = "/srv/haka/myfilter.lua";
        type = types.string;
        description = ''
          Specify which configuration file Haka uses.
          It can be absolute path or a path relative to the sample directory of
          the haka git repo.
        '';
      };

      interfaces = mkOption {
        default = [ "eth0" ];
        example = [ "any" ];
        type = with types; listOf string;
        description = ''
          Specify which interface(s) Haka listens to.
          Use 'any' to listen to all interfaces.
        '';
      };

      threads = mkOption {
        default = 0;
        example = 4;
        type = types.int;
        description = ''
          The number of threads that will be used.
          All system threads are used by default.
        '';
      };

      pcap = mkOption {
        default = true;
        example = false;
        type = types.bool;
        description = "Whether to enable pcap";
      };

      nfqueue = mkEnableOption "nfqueue";

      dump.enable = mkEnableOption "dump";
      dump.input  = mkOption {
        default = "/tmp/input.pcap";
        example = "/path/to/file.pcap";
        type = types.path;
        description = "Path to file where incoming packets are dumped";
      };

      dump.output  = mkOption {
        default = "/tmp/output.pcap";
        example = "/path/to/file.pcap";
        type = types.path;
        description = "Path to file where outgoing packets are dumped";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.pcap != cfg.nfqueue;
        message = "either pcap or nfqueue can be enabled, not both.";
      }
      { assertion = cfg.nfqueue -> !dump.enable;
        message = "dump can only be used with nfqueue.";
      }
      { assertion = cfg.interfaces != [];
        message = "at least one interface must be specified.";
      }];


    environment.systemPackages = [ haka ];

    systemd.services.haka = {
      description = "Haka";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${haka}/bin/haka -c ${hakaConf}";
        ExecStop = "${haka}/bin/hakactl stop";
        User = "root";
        Type = "forking";
      };
    };
  };
}

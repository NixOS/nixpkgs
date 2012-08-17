{ config, pkgs }:

with pkgs.lib;

{

  serviceOptions = {

    description = mkOption {
      default = "";
      types = types.uniq types.string;
      description = "Description of this unit used in systemd messages and progress indicators.";
    };

    requires = mkOption {
      default = [];
      types = types.listOf types.string;
      description = ''
        Start the specified units when this unit is started, and stop
        this unit when the specified units are stopped or fail.
      '';
    };

    wants = mkOption {
      default = [];
      types = types.listOf types.string;
      description = ''
        Start the specified units when this unit is started.
      '';
    };

    after = mkOption {
      default = [];
      types = types.listOf types.string;
      description = ''
        If the specified units are started at the same time as
        this unit, delay this unit until they have started.
      '';
    };

    before = mkOption {
      default = [];
      types = types.listOf types.string;
      description = ''
        If the specified units are started at the same time as
        this unit, delay them until this unit has started.
      '';
    };

    partOf = mkOption {
      default = [];
      types = types.listOf types.string;
      description = ''
        If the specified units are stopped or restarted, then this
        unit is stopped or restarted as well.
      '';
    };

    wantedBy = mkOption {
      default = [];
      types = types.listOf types.string;
      description = "Units that want (i.e. depend on) this unit.";
    };

    environment = mkOption {
      default = {};
      type = types.attrs;
      example = { PATH = "/foo/bar/bin"; LANG = "nl_NL.UTF-8"; };
      description = "Environment variables passed to the services's processes.";
    };

    path = mkOption {
      default = [];
      apply = ps: "${makeSearchPath "bin" ps}:${makeSearchPath "sbin" ps}";
      description = ''
        Packages added to the service's <envar>PATH</envar>
        environment variable.  Both the <filename>bin</filename>
        and <filename>sbin</filename> subdirectories of each
        package are added.
      '';
    };

    unitConfig = mkOption {
      default = "";
      type = types.string;
      description = ''
        Contents of the <literal>[Unit]</literal> section of the unit.
        See <citerefentry><refentrytitle>systemd.unit</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    serviceConfig = mkOption {
      default = "";
      type = types.string;
      description = ''
        Contents of the <literal>[Service]</literal> section of the unit.
        See <citerefentry><refentrytitle>systemd.service</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    script = mkOption {
      type = types.uniq types.string;
      default = "";
      description = "Shell commands executed as the service's main process.";
    };

    preStart = mkOption {
      type = types.string;
      default = "";
      description = ''
        Shell commands executed before the service's main process
        is started.
      '';
    };

    restartIfChanged = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether the service should be restarted during a NixOS
        configuration switch if its definition has changed.
      '';
    };

  };

}
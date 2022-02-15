{ lib, systemdUtils }:

with systemdUtils.lib;
with lib;

let
  checkService = checkUnitConfig "Service" [
    (assertValueOneOf "Type" [
      "exec" "simple" "forking" "oneshot" "dbus" "notify" "idle"
    ])
    (assertValueOneOf "Restart" [
      "no" "on-success" "on-failure" "on-abnormal" "on-abort" "always"
    ])
  ];

in rec {

  unitOption = mkOptionType {
    name = "systemd option";
    merge = loc: defs:
      let
        defs' = filterOverrides defs;
        defs'' = getValues defs';
      in
        if isList (head defs'')
        then concatLists defs''
        else mergeEqualOption loc defs';
  };

  sharedOptions = {

    enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        If set to false, this unit will be a symlink to
        /dev/null. This is primarily useful to prevent specific
        template instances
        (e.g. <literal>serial-getty@ttyS0</literal>) from being
        started. Note that <literal>enable=true</literal> does not
        make a unit start by default at boot; if you want that, see
        <literal>wantedBy</literal>.
      '';
    };

    requiredBy = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = ''
        Units that require (i.e. depend on and need to go down with)
        this unit. The discussion under <literal>wantedBy</literal>
        applies here as well: inverse <literal>.requires</literal>
        symlinks are established.
      '';
    };

    wantedBy = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = ''
        Units that want (i.e. depend on) this unit. The standard way
        to make a unit start by default at boot is to set this option
        to <literal>[ "multi-user.target" ]</literal>. That's despite
        the fact that the systemd.unit(5) manpage says this option
        goes in the <literal>[Install]</literal> section that controls
        the behaviour of <literal>systemctl enable</literal>. Since
        such a process is stateful and thus contrary to the design of
        NixOS, setting this option instead causes the equivalent
        inverse <literal>.wants</literal> symlink to be present,
        establishing the same desired relationship in a stateless way.
      '';
    };

    aliases = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = "Aliases of that unit.";
    };

  };

  concreteUnitOptions = sharedOptions // {

    text = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Text of this systemd unit.";
    };

    unit = mkOption {
      internal = true;
      description = "The generated unit.";
    };

  };

  commonUnitOptions = sharedOptions // {

    description = mkOption {
      default = "";
      type = types.singleLineStr;
      description = "Description of this unit used in systemd messages and progress indicators.";
    };

    documentation = mkOption {
      default = [];
      type = types.listOf types.str;
      description = "A list of URIs referencing documentation for this unit or its configuration.";
    };

    requires = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = ''
        Start the specified units when this unit is started, and stop
        this unit when the specified units are stopped or fail.
      '';
    };

    wants = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = ''
        Start the specified units when this unit is started.
      '';
    };

    after = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = ''
        If the specified units are started at the same time as
        this unit, delay this unit until they have started.
      '';
    };

    before = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = ''
        If the specified units are started at the same time as
        this unit, delay them until this unit has started.
      '';
    };

    bindsTo = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = ''
        Like ‘requires’, but in addition, if the specified units
        unexpectedly disappear, this unit will be stopped as well.
      '';
    };

    partOf = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = ''
        If the specified units are stopped or restarted, then this
        unit is stopped or restarted as well.
      '';
    };

    conflicts = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = ''
        If the specified units are started, then this unit is stopped
        and vice versa.
      '';
    };

    requisite = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = ''
        Similar to requires. However if the units listed are not started,
        they will not be started and the transaction will fail.
      '';
    };

    unitConfig = mkOption {
      default = {};
      example = { RequiresMountsFor = "/data"; };
      type = types.attrsOf unitOption;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Unit]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.unit</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    restartTriggers = mkOption {
      default = [];
      type = types.listOf types.unspecified;
      description = ''
        An arbitrary list of items such as derivations.  If any item
        in the list changes between reconfigurations, the service will
        be restarted.
      '';
    };

    reloadTriggers = mkOption {
      default = [];
      type = types.listOf unitOption;
      description = ''
        An arbitrary list of items such as derivations.  If any item
        in the list changes between reconfigurations, the service will
        be reloaded.  If anything but a reload trigger changes in the
        unit file, the unit will be restarted instead.
      '';
    };

    onFailure = mkOption {
      default = [];
      type = types.listOf unitNameType;
      description = ''
        A list of one or more units that are activated when
        this unit enters the "failed" state.
      '';
    };

    startLimitBurst = mkOption {
       type = types.int;
       description = ''
         Configure unit start rate limiting. Units which are started
         more than startLimitBurst times within an interval time
         interval are not permitted to start any more.
       '';
    };

    startLimitIntervalSec = mkOption {
       type = types.int;
       description = ''
         Configure unit start rate limiting. Units which are started
         more than startLimitBurst times within an interval time
         interval are not permitted to start any more.
       '';
    };

  };


  serviceOptions = commonUnitOptions // {

    environment = mkOption {
      default = {};
      type = with types; attrsOf (nullOr (oneOf [ str path package ]));
      example = { PATH = "/foo/bar/bin"; LANG = "nl_NL.UTF-8"; };
      description = "Environment variables passed to the service's processes.";
    };

    path = mkOption {
      default = [];
      type = with types; listOf (oneOf [ package str ]);
      description = ''
        Packages added to the service's <envar>PATH</envar>
        environment variable.  Both the <filename>bin</filename>
        and <filename>sbin</filename> subdirectories of each
        package are added.
      '';
    };

    serviceConfig = mkOption {
      default = {};
      example =
        { RestartSec = 5;
        };
      type = types.addCheck (types.attrsOf unitOption) checkService;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Service]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.service</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    script = mkOption {
      type = types.lines;
      default = "";
      description = "Shell commands executed as the service's main process.";
    };

    scriptArgs = mkOption {
      type = types.str;
      default = "";
      description = "Arguments passed to the main process script.";
    };

    preStart = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Shell commands executed before the service's main process
        is started.
      '';
    };

    postStart = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Shell commands executed after the service's main process
        is started.
      '';
    };

    reload = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Shell commands executed when the service's main process
        is reloaded.
      '';
    };

    preStop = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Shell commands executed to stop the service.
      '';
    };

    postStop = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Shell commands executed after the service's main process
        has exited.
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

    reloadIfChanged = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether the service should be reloaded during a NixOS
        configuration switch if its definition has changed.  If
        enabled, the value of <option>restartIfChanged</option> is
        ignored.

        This option should not be used anymore in favor of
        <option>reloadTriggers</option> which allows more granular
        control of when a service is reloaded and when a service
        is restarted.
      '';
    };

    stopIfChanged = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If set, a changed unit is restarted by calling
        <command>systemctl stop</command> in the old configuration,
        then <command>systemctl start</command> in the new one.
        Otherwise, it is restarted in a single step using
        <command>systemctl restart</command> in the new configuration.
        The latter is less correct because it runs the
        <literal>ExecStop</literal> commands from the new
        configuration.
      '';
    };

    startAt = mkOption {
      type = with types; either str (listOf str);
      default = [];
      example = "Sun 14:00:00";
      description = ''
        Automatically start this unit at the given date/time, which
        must be in the format described in
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>.  This is equivalent
        to adding a corresponding timer unit with
        <option>OnCalendar</option> set to the value given here.
      '';
      apply = v: if isList v then v else [ v ];
    };

  };


  socketOptions = commonUnitOptions // {

    listenStreams = mkOption {
      default = [];
      type = types.listOf types.str;
      example = [ "0.0.0.0:993" "/run/my-socket" ];
      description = ''
        For each item in this list, a <literal>ListenStream</literal>
        option in the <literal>[Socket]</literal> section will be created.
      '';
    };

    listenDatagrams = mkOption {
      default = [];
      type = types.listOf types.str;
      example = [ "0.0.0.0:993" "/run/my-socket" ];
      description = ''
        For each item in this list, a <literal>ListenDatagram</literal>
        option in the <literal>[Socket]</literal> section will be created.
      '';
    };

    socketConfig = mkOption {
      default = {};
      example = { ListenStream = "/run/my-socket"; };
      type = types.attrsOf unitOption;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Socket]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.socket</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };


  timerOptions = commonUnitOptions // {

    timerConfig = mkOption {
      default = {};
      example = { OnCalendar = "Sun 14:00:00"; Unit = "foo.service"; };
      type = types.attrsOf unitOption;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Timer]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.timer</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> and
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry> for details.
      '';
    };

  };


  pathOptions = commonUnitOptions // {

    pathConfig = mkOption {
      default = {};
      example = { PathChanged = "/some/path"; Unit = "changedpath.service"; };
      type = types.attrsOf unitOption;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Path]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.path</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };


  mountOptions = commonUnitOptions // {

    what = mkOption {
      example = "/dev/sda1";
      type = types.str;
      description = "Absolute path of device node, file or other resource. (Mandatory)";
    };

    where = mkOption {
      example = "/mnt";
      type = types.str;
      description = ''
        Absolute path of a directory of the mount point.
        Will be created if it doesn't exist. (Mandatory)
      '';
    };

    type = mkOption {
      default = "";
      example = "ext4";
      type = types.str;
      description = "File system type.";
    };

    options = mkOption {
      default = "";
      example = "noatime";
      type = types.commas;
      description = "Options used to mount the file system.";
    };

    mountConfig = mkOption {
      default = {};
      example = { DirectoryMode = "0775"; };
      type = types.attrsOf unitOption;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Mount]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.mount</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };
  };

  automountOptions = commonUnitOptions // {

    where = mkOption {
      example = "/mnt";
      type = types.str;
      description = ''
        Absolute path of a directory of the mount point.
        Will be created if it doesn't exist. (Mandatory)
      '';
    };

    automountConfig = mkOption {
      default = {};
      example = { DirectoryMode = "0775"; };
      type = types.attrsOf unitOption;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Automount]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.automount</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };
  };

  targetOptions = commonUnitOptions;

  sliceOptions = commonUnitOptions // {

    sliceConfig = mkOption {
      default = {};
      example = { MemoryMax = "2G"; };
      type = types.attrsOf unitOption;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Slice]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.slice</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };

}

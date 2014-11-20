{ config, lib }:

with lib;

let

  boolValues = [true false "yes" "no"];

  assertValueOneOf = name: values: group: attr:
    optional (attr ? ${name} && !elem attr.${name} values)
      "Systemd ${group} field `${name}' cannot have value `${attr.${name}}'.";

  assertHasField = name: group: attr:
    optional (!(attr ? ${name}))
      "Systemd ${group} field `${name}' must exist.";

  assertOnlyFields = fields: group: attr:
    let badFields = filter (name: ! elem name fields) (attrNames attr); in
    optional (badFields != [ ])
      "Systemd ${group} has extra fields [${concatStringsSep " " badFields}].";

  assertRange = name: min: max: group: attr:
    optional (attr ? ${name} && !(min <= attr.${name} && max >= attr.${name}))
      "Systemd ${group} field `${name}' is outside the range [${toString min},${toString max}]";

  digits = map toString (range 0 9);

  isByteFormat = s:
    let
      l = reverseList (stringToCharacters s);
      suffix = head l;
      nums = tail l;
    in elem suffix (["K" "M" "G" "T"] ++ digits)
      && all (num: elem num digits) nums;

  assertByteFormat = name: group: attr:
    optional (attr ? ${name} && ! isByteFormat attr.${name})
      "Systemd ${group} field `${name}' must be in byte format [0-9]+[KMGT].";

  hexChars = stringToCharacters "0123456789abcdefABCDEF";

  isMacAddress = s: stringLength s == 17
    && flip all (splitString ":" s) (bytes:
      all (byte: elem byte hexChars) (stringToCharacters bytes)
    );

  assertMacAddress = name: group: attr:
    optional (attr ? ${name} && ! isMacAddress attr.${name})
      "Systemd ${group} field `${name}' must be a valid mac address.";

  checkUnitConfig = group: checks: v:
    let errors = concatMap (c: c group v) checks; in
    if errors == [] then true
      else builtins.trace (concatStringsSep "\n" errors) false;

  checkService = checkUnitConfig "Service" [
    (assertValueOneOf "Type" [
      "simple" "forking" "oneshot" "dbus" "notify" "idle"
    ])
    (assertValueOneOf "Restart" [
      "no" "on-success" "on-failure" "on-abort" "always"
    ])
  ];

  checkLink = checkUnitConfig "Link" [
    (assertOnlyFields [
      "Description" "Alias" "MACAddressPolicy" "MACAddress" "NamePolicy" "Name"
      "MTUBytes" "BitsPerSecond" "Duplex" "WakeOnLan"
    ])
    (assertValueOneOf "MACAddressPolicy" ["persistent" "random"])
    (assertMacAddress "MACAddress")
    (assertValueOneOf "NamePolicy" [
      "kernel" "database" "onboard" "slot" "path" "mac"
    ])
    (assertByteFormat "MTUBytes")
    (assertByteFormat "BitsPerSecond")
    (assertValueOneOf "Duplex" ["half" "full"])
    (assertValueOneOf "WakeOnLan" ["phy" "magic" "off"])
  ];

  checkNetdev = checkUnitConfig "Netdev" [
    (assertOnlyFields [
      "Description" "Name" "Kind" "MTUBytes" "MACAddress"
    ])
    (assertHasField "Name")
    (assertHasField "Kind")
    (assertValueOneOf "Kind" [
      "bridge" "bond" "vlan" "macvlan" "vxlan" "ipip"
      "gre" "sit" "vti" "veth" "tun" "tap" "dummy"
    ])
    (assertByteFormat "MTUBytes")
    (assertMacAddress "MACAddress")
  ];

  checkVlan = checkUnitConfig "VLAN" [
    (assertOnlyFields ["Id"])
    (assertRange "Id" 0 4094)
  ];

  checkMacvlan = checkUnitConfig "MACVLAN" [
    (assertOnlyFields ["Mode"])
    (assertValueOneOf "Mode" ["private" "vepa" "bridge" "passthru"])
  ];

  checkVxlan = checkUnitConfig "VXLAN" [
    (assertOnlyFields ["Id" "Group" "TOS" "TTL" "MacLearning"])
    (assertRange "TTL" 0 255)
    (assertValueOneOf "MacLearning" boolValues)
  ];

  checkTunnel = checkUnitConfig "Tunnel" [
    (assertOnlyFields ["Local" "Remote" "TOS" "TTL" "DiscoverPathMTU"])
    (assertRange "TTL" 0 255)
    (assertValueOneOf "DiscoverPathMTU" boolValues)
  ];

  checkPeer = checkUnitConfig "Peer" [
    (assertOnlyFields ["Name" "MACAddress"])
    (assertMacAddress "MACAddress")
  ];

  tunTapChecks = [
    (assertOnlyFields ["OneQueue" "MultiQueue" "PacketInfo" "User" "Group"])
    (assertValueOneOf "OneQueue" boolValues)
    (assertValueOneOf "MultiQueue" boolValues)
    (assertValueOneOf "PacketInfo" boolValues)
  ];

  checkTun = checkUnitConfig "Tun" tunTapChecks;

  checkTap = checkUnitConfig "Tap" tunTapChecks;

  checkBond = checkUnitConfig "Bond" [
    (assertOnlyFields [
      "Mode" "TransmitHashPolicy" "LACPTransmitRate" "MIIMonitorSec"
      "UpDelaySec" "DownDelaySec"
    ])
    (assertValueOneOf "Mode" [
      "balance-rr" "active-backup" "balance-xor"
      "broadcast" "802.3ad" "balance-tlb" "balance-alb"
    ])
    (assertValueOneOf "TransmitHashPolicy" [
      "layer2" "layer3+4" "layer2+3" "encap2+3" "802.3ad" "encap3+4"
    ])
    (assertValueOneOf "LACPTransmitRate" ["slow" "fast"])
  ];

  checkNetwork = checkUnitConfig "Network" [
    (assertOnlyFields [
      "Description" "DHCP" "DHCPServer" "IPv4LL" "IPv4LLRoute"
      "LLMNR" "Domains" "Bridge" "Bond"
    ])
    (assertValueOneOf "DHCP" ["both" "none" "v4" "v6"])
    (assertValueOneOf "DHCPServer" boolValues)
    (assertValueOneOf "IPv4LL" boolValues)
    (assertValueOneOf "IPv4LLRoute" boolValues)
    (assertValueOneOf "LLMNR" boolValues)
  ];

  checkAddress = checkUnitConfig "Address" [
    (assertOnlyFields ["Address" "Peer" "Broadcast" "Label"])
    (assertHasField "Address")
  ];

  checkRoute = checkUnitConfig "Route" [
    (assertOnlyFields ["Gateway" "Destination" "Metric"])
    (assertHasField "Gateway")
  ];

  checkDhcp = checkUnitConfig "DHCP" [
    (assertOnlyFields [
      "UseDNS" "UseMTU" "SendHostname" "UseHostname" "UseDomains" "UseRoutes"
      "CriticalConnections" "VendorClassIdentifier" "RequestBroadcast"
      "RouteMetric"
    ])
    (assertValueOneOf "UseDNS" boolValues)
    (assertValueOneOf "UseMTU" boolValues)
    (assertValueOneOf "SendHostname" boolValues)
    (assertValueOneOf "UseHostname" boolValues)
    (assertValueOneOf "UseDomains" boolValues)
    (assertValueOneOf "UseRoutes" boolValues)
    (assertValueOneOf "CriticalConnections" boolValues)
    (assertValueOneOf "RequestBroadcast" boolValues)
  ];

  unitOption = mkOptionType {
    name = "systemd option";
    merge = loc: defs:
      let
        defs' = filterOverrides defs;
        defs'' = getValues defs';
      in
        if isList (head defs'')
        then concatLists defs''
        else mergeOneOption loc defs';
  };

in rec {

  sharedOptions = {

    enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        If set to false, this unit will be a symlink to
        /dev/null. This is primarily useful to prevent specific
        template instances (e.g. <literal>serial-getty@ttyS0</literal>)
        from being started.
      '';
    };

    requiredBy = mkOption {
      default = [];
      type = types.listOf types.string;
      description = "Units that require (i.e. depend on and need to go down with) this unit.";
    };

    wantedBy = mkOption {
      default = [];
      type = types.listOf types.string;
      description = "Units that want (i.e. depend on) this unit.";
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
      type = types.str;
      description = "Description of this unit used in systemd messages and progress indicators.";
    };

    requires = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        Start the specified units when this unit is started, and stop
        this unit when the specified units are stopped or fail.
      '';
    };

    wants = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        Start the specified units when this unit is started.
      '';
    };

    after = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        If the specified units are started at the same time as
        this unit, delay this unit until they have started.
      '';
    };

    before = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        If the specified units are started at the same time as
        this unit, delay them until this unit has started.
      '';
    };

    bindsTo = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        Like ‘requires’, but in addition, if the specified units
        unexpectedly disappear, this unit will be stopped as well.
      '';
    };

    partOf = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        If the specified units are stopped or restarted, then this
        unit is stopped or restarted as well.
      '';
    };

    conflicts = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        If the specified units are started, then this unit is stopped
        and vice versa.
      '';
    };

    requisite = mkOption {
      default = [];
      type = types.listOf types.str;
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

  };


  serviceOptions = commonUnitOptions // {

    environment = mkOption {
      default = {};
      type = types.attrs; # FIXME
      example = { PATH = "/foo/bar/bin"; LANG = "nl_NL.UTF-8"; };
      description = "Environment variables passed to the service's processes.";
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

    serviceConfig = mkOption {
      default = {};
      example =
        { StartLimitInterval = 10;
          RestartSec = 5;
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
      type = types.str;
      default = "";
      example = "Sun 14:00:00";
      description = ''
        Automatically start this unit at the given date/time, which
        must be in the format described in
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry>.  This is equivalent
        to adding a corresponding timer unit with
        <option>OnCalendar</option> set to the value given here.
      '';
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
        <manvolnum>5</manvolnum></citerefentry> for details.
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

  commonNetworkOptions = {

    enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        If set to false, this unit will be a symlink to
        /dev/null.
      '';
    };

    matchConfig = mkOption {
      default = {};
      example = { Name = "eth0"; };
      type = types.attrsOf unitOption;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Match]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.link</refentrytitle><manvolnum>5</manvolnum></citerefentry>
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle><manvolnum>5</manvolnum></citerefentry>
        <citerefentry><refentrytitle>systemd.network</refentrytitle><manvolnum>5</manvolnum></citerefentry>
        for details.
      '';
    };

  };

  linkOptions = commonNetworkOptions // {

    linkConfig = mkOption {
      default = {};
      example = { MACAddress = "00:ff:ee:aa:cc:dd"; };
      type = types.addCheck (types.attrsOf unitOption) checkLink;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Link]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.link</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };

  netdevOptions = commonNetworkOptions // {

    netdevConfig = mkOption {
      default = {};
      example = { Name = "mybridge"; Kind = "bridge"; };
      type = types.addCheck (types.attrsOf unitOption) checkNetdev;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Netdev]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    vlanConfig = mkOption {
      default = {};
      example = { Id = "4"; };
      type = types.addCheck (types.attrsOf unitOption) checkVlan;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[VLAN]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    macvlanConfig = mkOption {
      default = {};
      example = { Mode = "private"; };
      type = types.addCheck (types.attrsOf unitOption) checkMacvlan;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[MACVLAN]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    vxlanConfig = mkOption {
      default = {};
      example = { Id = "4"; };
      type = types.addCheck (types.attrsOf unitOption) checkVxlan;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[VXLAN]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    tunnelConfig = mkOption {
      default = {};
      example = { Remote = "192.168.1.1"; };
      type = types.addCheck (types.attrsOf unitOption) checkTunnel;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Tunnel]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    peerConfig = mkOption {
      default = {};
      example = { Name = "veth2"; };
      type = types.addCheck (types.attrsOf unitOption) checkPeer;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Peer]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    tunConfig = mkOption {
      default = {};
      example = { User = "openvpn"; };
      type = types.addCheck (types.attrsOf unitOption) checkTun;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Tun]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    tapConfig = mkOption {
      default = {};
      example = { User = "openvpn"; };
      type = types.addCheck (types.attrsOf unitOption) checkTap;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Tap]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    bondConfig = mkOption {
      default = {};
      example = { Mode = "802.3ad"; };
      type = types.addCheck (types.attrsOf unitOption) checkBond;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Bond]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.netdev</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };

  addressOptions = {

    addressConfig = mkOption {
      default = {};
      example = { Address = "192.168.0.100/24"; };
      type = types.addCheck (types.attrsOf unitOption) checkAddress;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Address]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };

  routeOptions = {

    routeConfig = mkOption {
      default = {};
      example = { Gateway = "192.168.0.1"; };
      type = types.addCheck (types.attrsOf unitOption) checkRoute;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Route]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };

  networkOptions = commonNetworkOptions // {

    networkConfig = mkOption {
      default = {};
      example = { Description = "My Network"; };
      type = types.addCheck (types.attrsOf unitOption) checkNetwork;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[Network]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    dhcpConfig = mkOption {
      default = {};
      example = { UseDNS = true; UseRoutes = true; };
      type = types.addCheck (types.attrsOf unitOption) checkDhcp;
      description = ''
        Each attribute in this set specifies an option in the
        <literal>[DHCP]</literal> section of the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    name = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The name of the network interface to match against.
      '';
    };

    DHCP = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Whether to enable DHCP on the interfaces matched.
      '';
    };

    domains = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
        A list of domains to pass to the network config.
      '';
    };

    address = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of addresses to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    gateway = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of gateways to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    dns = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of dns servers to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    ntp = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of ntp servers to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    vlan = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of vlan interfaces to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    macvlan = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of macvlan interfaces to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    vxlan = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of vxlan interfaces to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    tunnel = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        A list of tunnel interfaces to be added to the network section of the
        unit.  See <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    addresses = mkOption {
      default = [ ];
      type = types.listOf types.optionSet;
      options = [ addressOptions ];
      description = ''
        A list of address sections to be added to the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

    routes = mkOption {
      default = [ ];
      type = types.listOf types.optionSet;
      options = [ routeOptions ];
      description = ''
        A list of route sections to be added to the unit.  See
        <citerefentry><refentrytitle>systemd.network</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> for details.
      '';
    };

  };

}

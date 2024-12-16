import ./make-test-python.nix (
  { lib, ... }:
  let
    execOptions = [
      "Boot"
      "ProcessTwo"
      "Parameters"
      "Environment"
      "User"
      "WorkingDirectory"
      "PivotRoot"
      "Capability"
      "DropCapability"
      "NoNewPrivileges"
      "KillSignal"
      "Personality"
      "MachineID"
      "PrivateUsers"
      "NotifyReady"
      "SystemCallFilter"
      "LimitCPU"
      "LimitFSIZE"
      "LimitDATA"
      "LimitSTACK"
      "LimitCORE"
      "LimitRSS"
      "LimitNOFILE"
      "LimitAS"
      "LimitNPROC"
      "LimitMEMLOCK"
      "LimitLOCKS"
      "LimitSIGPENDING"
      "LimitMSGQUEUE"
      "LimitNICE"
      "LimitRTPRIO"
      "LimitRTTIME"
      "OOMScoreAdjust"
      "CPUAffinity"
      "Hostname"
      "ResolvConf"
      "Timezone"
      "LinkJournal"
      "Ephemeral"
      "AmbientCapability"
    ];

    filesOptions = [
      "ReadOnly"
      "Volatile"
      "Bind"
      "BindReadOnly"
      "TemporaryFileSystem"
      "Overlay"
      "OverlayReadOnly"
      "PrivateUsersChown"
      "BindUser"
      "Inaccessible"
      "PrivateUsersOwnership"
    ];

    networkOptions = [
      "Private"
      "VirtualEthernet"
      "VirtualEthernetExtra"
      "Interface"
      "MACVLAN"
      "IPVLAN"
      "Bridge"
      "Zone"
      "Port"
    ];

    optionsToConfig = opts: builtins.listToAttrs (map (n: lib.nameValuePair n "testdata") opts);

    grepForOptions = opts: ''
      node.succeed(
          "for o in ${builtins.concatStringsSep " " opts} ; do grep --quiet $o ${configFile} || exit 1 ; done"
        )'';

    unitName = "options-test";
    configFile = "/etc/systemd/nspawn/${unitName}.nspawn";

  in
  {
    name = "systemd-nspawn-configfile";

    nodes = {
      node =
        { pkgs, ... }:
        {
          systemd.nspawn."${unitName}" = {
            enable = true;

            execConfig = optionsToConfig execOptions // {
              Boot = true;
              ProcessTwo = true;
              NotifyReady = true;
            };

            filesConfig = optionsToConfig filesOptions // {
              ReadOnly = true;
              Volatile = "state";
              PrivateUsersChown = true;
              PrivateUsersOwnership = "auto";
            };

            networkConfig = optionsToConfig networkOptions // {
              Private = true;
              VirtualEthernet = true;
            };
          };
        };
    };

    testScript = ''
      start_all()

      node.wait_for_file("${configFile}")

      with subtest("Test for presence of all specified options in config file"):
        ${grepForOptions execOptions}
        ${grepForOptions filesOptions}
        ${grepForOptions networkOptions}

      with subtest("Test for absence of misspelled option 'MachineId' (instead of 'MachineID')"):
        node.fail("grep --quiet MachineId ${configFile}")
    '';

    meta.maintainers = [
      lib.maintainers.zi3m5f
    ];
  }
)

{
  config,
  lib,
  utils,
  ...
}:

let

  inherit (utils.systemdUtils.lib)
    checkUnitConfig
    assertOnlyFields
    assertValueOneOf
    attrsToSection
    makeUnit
    generateUnits

  ;
  cfg = config.systemd.nspawn;

  checkExec = checkUnitConfig "Exec" [
    (assertOnlyFields [
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
    ])
    (assertValueOneOf "Boot" lib.boolValues)
    (assertValueOneOf "ProcessTwo" lib.boolValues)
    (assertValueOneOf "NotifyReady" lib.boolValues)
  ];

  checkFiles = checkUnitConfig "Files" [
    (assertOnlyFields [
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
    ])
    (assertValueOneOf "ReadOnly" lib.boolValues)
    (assertValueOneOf "Volatile" (lib.boolValues ++ [ "state" ]))
    (assertValueOneOf "PrivateUsersChown" lib.boolValues)
    (assertValueOneOf "PrivateUsersOwnership" [
      "off"
      "chown"
      "map"
      "auto"
    ])
  ];

  checkNetwork = checkUnitConfig "Network" [
    (assertOnlyFields [
      "Private"
      "VirtualEthernet"
      "VirtualEthernetExtra"
      "Interface"
      "MACVLAN"
      "IPVLAN"
      "Bridge"
      "Zone"
      "Port"
    ])
    (assertValueOneOf "Private" lib.boolValues)
    (assertValueOneOf "VirtualEthernet" lib.boolValues)
  ];

  instanceOptions = {
    options = (lib.getAttrs [ "enable" ] utils.systemdUtils.unitOptions.sharedOptions) // {
      execConfig = lib.mkOption {
        default = { };
        example = {
          Parameters = "/bin/sh";
        };
        type = lib.types.addCheck (lib.types.attrsOf utils.systemdUtils.unitOption) checkExec;
        description = ''
          Each attribute in this set specifies an option in the
          `[Exec]` section of this unit. See
          {manpage}`systemd.nspawn(5)` for details.
        '';
      };

      filesConfig = lib.mkOption {
        default = { };
        example = {
          Bind = [ "/home/alice" ];
        };
        type = lib.types.addCheck (lib.types.attrsOf utils.systemdUtils.unitOption) checkFiles;
        description = ''
          Each attribute in this set specifies an option in the
          `[Files]` section of this unit. See
          {manpage}`systemd.nspawn(5)` for details.
        '';
      };

      networkConfig = lib.mkOption {
        default = { };
        example = {
          Private = false;
        };
        type = lib.types.addCheck (lib.types.attrsOf utils.systemdUtils.unitOption) checkNetwork;
        description = ''
          Each attribute in this set specifies an option in the
          `[Network]` section of this unit. See
          {manpage}`systemd.nspawn(5)` for details.
        '';
      };
    };

  };

  instanceToUnit =
    name: def:
    let
      base = {
        text = ''
          [Exec]
          ${attrsToSection def.execConfig}

          [Files]
          ${attrsToSection def.filesConfig}

          [Network]
          ${attrsToSection def.networkConfig}
        '';
      } // def;
    in
    base // { unit = makeUnit name base; };

in
{

  options = {

    systemd.nspawn = lib.mkOption {
      default = { };
      type = with lib.types; attrsOf (submodule instanceOptions);
      description = "Definition of systemd-nspawn configurations.";
    };

  };

  config =
    let
      units = lib.mapAttrs' (
        n: v:
        let
          nspawnFile = "${n}.nspawn";
        in
        lib.nameValuePair nspawnFile (instanceToUnit nspawnFile v)
      ) cfg;
    in
    lib.mkMerge [
      (lib.mkIf (cfg != { }) {
        environment.etc."systemd/nspawn".source = lib.mkIf (cfg != { }) (generateUnits {
          allowCollisions = false;
          type = "nspawn";
          inherit units;
          upstreamUnits = [ ];
          upstreamWants = [ ];
        });
      })
      {
        systemd.targets.multi-user.wants = [ "machines.target" ];
        systemd.services."systemd-nspawn@".environment = {
          SYSTEMD_NSPAWN_UNIFIED_HIERARCHY = lib.mkDefault "1";
        };
      }
    ];
}

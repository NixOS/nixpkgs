{ config, lib , pkgs, ...}:

with lib;
with import ./systemd-unit-options.nix { inherit config lib; };
with import ./systemd-lib.nix { inherit config lib pkgs; };

let
  cfg = config.systemd.nspawn;
  assertions = [
    # boot = true -> processtwo != true
  ];

  checkExec = checkUnitConfig "Exec" [
    (assertOnlyFields [
      "Boot" "ProcessTwo" "Parameters" "Environment" "User" "WorkingDirectory"
      "Capability" "DropCapability" "KillSignal" "Personality" "MachineId"
      "PrivateUsers" "NotifyReady"
    ])
    (assertValueOneOf "Boot" boolValues)
    (assertValueOneOf "ProcessTwo" boolValues)
    (assertValueOneOf "NotifyReady" boolValues)
  ];

  checkFiles = checkUnitConfig "Files" [
    (assertOnlyFields [
      "ReadOnly" "Volatile" "Bind" "BindReadOnly" "TemporaryFileSystems"
      "PrivateUsersChown"
    ])
    (assertValueOneOf "ReadOnly" boolValues)
    (assertValueOneOf "Volatile" (boolValues ++ [ "state" ]))
    (assertValueOneOf "PrivateUsersChown" boolValues)
  ];

  checkNetwork = checkUnitConfig "Network" [
    (assertOnlyFields [
      "Private" "VirtualEthernet" "VirtualEthernetExtra" "Interface" "MACVLAN"
      "IPVLAN" "Bridge" "Zone" "Port"
    ])
    (assertValueOneOf "Private" boolValues)
    (assertValueOneOf "VirtualEthernet" boolValues)
  ];

  instanceOptions = {
    options = sharedOptions // {
      execConfig = mkOption {
        default = {};
        example = { Parameters = "/bin/sh"; };
        type = types.addCheck (types.attrsOf unitOption) checkExec;
        description = ''
          Each attribute in this set specifies an option in the
          <literal>[Exec]</literal> section of this unit. See
          <citerefentry><refentrytitle>systemd.nspawn</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry> for details.
        '';
      };

      filesConfig = mkOption {
        default = {};
        example = { Bind = [ "/home/alice" ]; };
        type = types.addCheck (types.attrsOf unitOption) checkFiles;
        description = ''
          Each attribute in this set specifies an option in the
          <literal>[Files]</literal> section of this unit. See
          <citerefentry><refentrytitle>systemd.nspawn</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry> for details.
        '';
      };

      networkConfig = mkOption {
        default = {};
        example = { Private = false; };
        type = types.addCheck (types.attrsOf unitOption) checkNetwork;
        description = ''
          Each attribute in this set specifies an option in the
          <literal>[Network]</literal> section of this unit. See
          <citerefentry><refentrytitle>systemd.nspawn</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry> for details.
        '';
      };
    };

  };

  instanceToUnit = name: def:
    let base = {
      text = ''
        [Exec]
        ${attrsToSection def.execConfig}

        [Files]
        ${attrsToSection def.filesConfig}

        [Network]
        ${attrsToSection def.networkConfig}
      '';
    } // def;
    in base // { unit = makeUnit name base; };

in {

  options = {

    systemd.nspawn = mkOption {
      default = {};
      type = with types; attrsOf (submodule instanceOptions);
      description = "Definition of systemd-nspawn configurations.";
    };

  };

  config =
    let
      units = mapAttrs' (n: v: nameValuePair "${n}.nspawn" (instanceToUnit n v)) cfg;
    in mkIf (cfg != {}) {

      environment.etc."systemd/nspawn".source = generateUnits "nspawn" units [] [];

      systemd.services."systemd-nspawn@" = {
        wantedBy = [ "machine.target" ];
      };
  };

}

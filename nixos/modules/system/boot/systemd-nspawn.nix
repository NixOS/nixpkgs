{ config, lib , pkgs, ...}:

with lib;
with import ./systemd-unit-options.nix { inherit config lib; };
with import ./systemd-lib.nix { inherit config lib pkgs; };

let
  cfg = config.systemd.nspawn;

  checkExec = checkUnitConfig "Exec" [
    (assertOnlyFields [
      "Boot" "ProcessTwo" "Parameters" "Environment" "User" "WorkingDirectory"
      "PivotRoot" "Capability" "DropCapability" "NoNewPrivileges" "KillSignal"
      "Personality" "MachineId" "PrivateUsers" "NotifyReady" "SystemCallFilter"
      "LimitCPU" "LimitFSIZE" "LimitDATA" "LimitSTACK" "LimitCORE" "LimitRSS"
      "LimitNOFILE" "LimitAS" "LimitNPROC" "LimitMEMLOCK" "LimitLOCKS"
      "LimitSIGPENDING" "LimitMSGQUEUE" "LimitNICE" "LimitRTPRIO" "LimitRTTIME"
      "OOMScoreAdjust" "CPUAffinity" "Hostname" "ResolvConf" "Timezone"
      "LinkJournal"
    ])
    (assertValueOneOf "Boot" boolValues)
    (assertValueOneOf "ProcessTwo" boolValues)
    (assertValueOneOf "NotifyReady" boolValues)
  ];

  checkFiles = checkUnitConfig "Files" [
    (assertOnlyFields [
      "ReadOnly" "Volatile" "Bind" "BindReadOnly" "TemporaryFileSystem"
      "Inaccessible" "Overlay" "OverlayReadOnly" "PrivateUsersChown"
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

  bindMounts = mkOption {
    type = with types; attrsOf (submodule {
      options = {
        source = mkOption {
          type = str;
          default = "";
          description = "Optional mount source path. If omitted, the specified path will be mounted from the host to the same path in the container.";
        };
        mountOption = mkOption {
          type = str;
          default = "";
          description = ''
            Optional mount options. See
            <link xlink:href="url">https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html#Mount%20Options</link>
            for more info.
          '';
        };
      };
    });
    default = {};
    example = { "/nix/store" = { source = "/nix/store"; mountOption = ""; }; };
    description = "Mount host path into container.";
  };

  fromBindMounts = mapAttrsToList (dest: { source, mountOption, ... }:
    if mountOption != "" then "${source}:${dest}:${mountOption}"
    else if source != "" then "${source}:${dest}"
    else toString dest);

  fromTmpfsMounts = map (dest:
    if builtins.isString dest then dest
    else "${dest.path}:${dest.mountOption}");

  fromInaccessibles = map toString;

  overlayMounts = mkOption {
    type = with types; attrsOf (listOf str);
    default = {};
    example = { "/var" = [ "+/readonly-var" "" ]; };
    description = "Mount host path into the container.";
  };

  fromOverlayMounts = mapAttrsToList (dest: sources:
    if length sources == 0 then throw "Overlay mount source path list is empty."
    else "${concatStringsSep ":" sources}:${dest}");

  fromVeths = mapAttrsToList (container: host: "${host}:${container}");

  instanceOptions = {
    options = {

      environment = mkOption {
        default = {};
        example = { PATH = "/run/current-system/sw/bin"; };
        type = with types; attrsOf (nullOr (oneOf [ int str path package ]));
        description = "Environment variables passed to the container's init.";
      };

      bind = bindMounts;
      bindReadOnly = bindMounts;

      temporaryFileSystem = mkOption {
        type = with types; listOf
          (oneOf
            [ str
              (submodule {
                options = {
                  path = mkOption {
                    type = str;
                    default = "";
                    description = "mount destination";
                  };
                  mountOption = mkOption {
                    type = str;
                    default = "";
                    description = ''
                      Mount options. See
                      <link xlink:href="url">https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html#Mount%20Options</link>
                      for more info.
                    '';
                  };
                };
              })
            ]
          );
        default = [];
        example = [ "/tmp" { path = "/var/tmp"; mountOption = ""; } ];
        description = "Mount temporary file system into the container.";
      }; # path or path:opts

      inaccessible = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "/secret" ];
        description = "Make the specified path inaccessible in the container.";
      }; # path

      overlay = overlayMounts; # pathes...:destpath
      overlayReadOnly = overlayMounts;

      virtualEthernetExtra = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = { "veth-container" = "veth-host"; };
        description = "Extra container and host interface names.";
      };

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
        ${let env = def.environment;
          in concatMapStrings (n:
            let s = optionalString (env."${n}" != null)
              "Environment=${builtins.toJSON "${n}=${toString env.${n}}"}\n";
            # systemd max line length is now 1MiB
            # https://github.com/systemd/systemd/commit/e6dde451a51dc5aaa7f4d98d39b8fe735f73d2af
            in if stringLength s >= 1048576 then throw "The value of the environment variable ‘${n}’ in systemd service ‘${name}.nspawn is too long." else s) (attrNames env)}
        ${attrsToSection def.execConfig}

        [Files]
        ${ attrsToSection {
          BindReadOnly = fromBindMounts def.bindReadOnly;
          Bind = fromBindMounts def.bind;
          TemporaryFileSystem = fromTmpfsMounts def.temporaryFileSystem;
          Inaccessible = fromInaccessibles def.inaccessible;
          OverlayReadOnly = fromOverlayMounts def.overlayReadOnly;
          Overlay = fromOverlayMounts def.overlay;
        }}
        ${attrsToSection def.filesConfig}

        [Network]
        ${attrsToSection { VirtualEthernetExtra = fromVeths def.virtualEthernetExtra; }}
        ${attrsToSection def.networkConfig}
      '';
    };
    in base;

in {

  options = {

    systemd.nspawn = mkOption {
      default = {};
      type = with types; attrsOf (submodule instanceOptions);
      description = ''
        Definition of <citerefentry><refentrytitle>systemd.nspawn</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry> configurations.
      '';
    };

    systemd.disableUnprivilegedNspawn = mkOption {
      default = false;
      type = types.bool;
      description = ''
        If true, it disables unprivileged systemd-nspawn container so that
        <literal>/nix</literal> mountpoint in guest NixOS works correctly.
        It removes <literal>-U</literal> or
        <literal>--private-users=pick --private-users-chown</literal> options
        in <literal>serviceConfig.ExecStart</literal> by overriding upstream
        <literal>systemd-nspawn@.service</literal>.
        Default is false, because it can break <literal>systemd-nspawn@*.service</literal> having
        non-default <literal>serviceConfig.ExecStart</literal>.
      '';
    };

  };

  config =
    mkMerge [
      (mkIf (cfg != {}) {
        environment.etc = mapAttrs' (n: v:
          let nspawnFile = "${n}.nspawn";
          in nameValuePair "systemd/nspawn/${nspawnFile}" (instanceToUnit nspawnFile v)
          ) cfg;
      })
      { systemd.targets.multi-user.wants = [ "machines.target" ]; }
      (mkIf config.systemd.disableUnprivilegedNspawn {
        # Workaround for https://github.com/NixOS/nixpkgs/pull/67232#issuecomment-531315437 and https://github.com/systemd/systemd/issues/13622
        # Once systemd fixes this upstream, we can re-enable -U
        systemd.services."systemd-nspawn@".serviceConfig.ExecStart = [
          ""  # deliberately empty. signals systemd to override the ExecStart
          # Only difference between upstream is that we do not pass the -U flag
          "${config.systemd.package}/bin/systemd-nspawn --quiet --keep-unit --boot --link-journal=try-guest --network-veth --settings=override --machine=%i"
        ];
      })
    ];
}

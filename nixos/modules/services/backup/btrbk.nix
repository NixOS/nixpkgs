{ config, pkgs, lib, ... }:
let
  inherit (lib)
    concatLists
    concatMap
    concatMapStringsSep
    concatStringsSep
    filterAttrs
    isAttrs
    literalExpression
    mapAttrs'
    mapAttrsToList
    mkIf
    mkOption
    optionalString
    sort
    types
    ;

  # The priority of an option or section.
  # The configurations format are order-sensitive. Pairs are added as children of
  # the last sections if possible, otherwise, they start a new section.
  # We sort them in topological order:
  # 1. Leaf pairs.
  # 2. Sections that may contain (1).
  # 3. Sections that may contain (1) or (2).
  # 4. Etc.
  prioOf = { name, value }:
    if !isAttrs value then 0 # Leaf options.
    else {
      target = 1; # Contains: options.
      subvolume = 2; # Contains: options, target.
      volume = 3; # Contains: options, target, subvolume.
    }.${name} or (throw "Unknow section '${name}'");

  genConfig' = set: concatStringsSep "\n" (genConfig set);
  genConfig = set:
    let
      pairs = mapAttrsToList (name: value: { inherit name value; }) set;
      sortedPairs = sort (a: b: prioOf a < prioOf b) pairs;
    in
      concatMap genPair sortedPairs;
  genSection = sec: secName: value:
    [ "${sec} ${secName}" ] ++ map (x: " " + x) (genConfig value);
  genPair = { name, value }:
    if !isAttrs value
    then [ "${name} ${value}" ]
    else concatLists (mapAttrsToList (genSection name) value);

  sudo_doas =
    if config.security.sudo.enable then "sudo"
    else if config.security.doas.enable then "doas"
    else throw "The btrbk nixos module needs either sudo or doas enabled in the configuration";

  addDefaults = settings: { backend = "btrfs-progs-${sudo_doas}"; } // settings;

  mkConfigFile = name: settings: pkgs.writeTextFile {
    name = "btrbk-${name}.conf";
    text = genConfig' (addDefaults settings);
    checkPhase = ''
      set +e
      ${pkgs.btrbk}/bin/btrbk -c $out dryrun
      # According to btrbk(1), exit status 2 means parse error
      # for CLI options or the config file.
      if [[ $? == 2 ]]; then
        echo "Btrbk configuration is invalid:"
        cat $out
        exit 1
      fi
      set -e
    '';
  };

  cfg = config.services.btrbk;
  sshEnabled = cfg.sshAccess != [ ];
  serviceEnabled = cfg.instances != { };
in
{
  meta.maintainers = with lib.maintainers; [ oxalica ];

  options = {
    services.btrbk = {
      extraPackages = mkOption {
        description = lib.mdDoc "Extra packages for btrbk, like compression utilities for `stream_compress`";
        type = types.listOf types.package;
        default = [ ];
        example = literalExpression "[ pkgs.xz ]";
      };
      niceness = mkOption {
        description = lib.mdDoc "Niceness for local instances of btrbk. Also applies to remote ones connecting via ssh when positive.";
        type = types.ints.between (-20) 19;
        default = 10;
      };
      ioSchedulingClass = mkOption {
        description = lib.mdDoc "IO scheduling class for btrbk (see ionice(1) for a quick description). Applies to local instances, and remote ones connecting by ssh if set to idle.";
        type = types.enum [ "idle" "best-effort" "realtime" ];
        default = "best-effort";
      };
      instances = mkOption {
        description = lib.mdDoc "Set of btrbk instances. The instance named `btrbk` is the default one.";
        type = with types;
          attrsOf (
            submodule {
              options = {
                onCalendar = mkOption {
                  type = types.nullOr types.str;
                  default = "daily";
                  description = lib.mdDoc ''
                    How often this btrbk instance is started. See systemd.time(7) for more information about the format.
                    Setting it to null disables the timer, thus this instance can only be started manually.
                  '';
                };
                settings = mkOption {
                  type = let t = types.attrsOf (types.either types.str (t // { description = "instances of this type recursively"; })); in t;
                  default = { };
                  example = {
                    snapshot_preserve_min = "2d";
                    snapshot_preserve = "14d";
                    volume = {
                      "/mnt/btr_pool" = {
                        target = "/mnt/btr_backup/mylaptop";
                        subvolume = {
                          "rootfs" = { };
                          "home" = { snapshot_create = "always"; };
                        };
                      };
                    };
                  };
                  description = lib.mdDoc "configuration options for btrbk. Nested attrsets translate to subsections.";
                };
              };
            }
          );
        default = { };
      };
      sshAccess = mkOption {
        description = lib.mdDoc "SSH keys that should be able to make or push snapshots on this system remotely with btrbk";
        type = with types; listOf (
          submodule {
            options = {
              key = mkOption {
                type = str;
                description = lib.mdDoc "SSH public key allowed to login as user `btrbk` to run remote backups.";
              };
              roles = mkOption {
                type = listOf (enum [ "info" "source" "target" "delete" "snapshot" "send" "receive" ]);
                example = [ "source" "info" "send" ];
                description = lib.mdDoc "What actions can be performed with this SSH key. See ssh_filter_btrbk(1) for details";
              };
            };
          }
        );
        default = [ ];
      };
    };

  };
  config = mkIf (sshEnabled || serviceEnabled) {
    environment.systemPackages = [ pkgs.btrbk ] ++ cfg.extraPackages;
    security.sudo = mkIf (sudo_doas == "sudo") {
      extraRules = [
        {
            users = [ "btrbk" ];
            commands = [
            { command = "${pkgs.btrfs-progs}/bin/btrfs"; options = [ "NOPASSWD" ]; }
            { command = "${pkgs.coreutils}/bin/mkdir"; options = [ "NOPASSWD" ]; }
            { command = "${pkgs.coreutils}/bin/readlink"; options = [ "NOPASSWD" ]; }
            # for ssh, they are not the same than the one hard coded in ${pkgs.btrbk}
            { command = "/run/current-system/bin/btrfs"; options = [ "NOPASSWD" ]; }
            { command = "/run/current-system/sw/bin/mkdir"; options = [ "NOPASSWD" ]; }
            { command = "/run/current-system/sw/bin/readlink"; options = [ "NOPASSWD" ]; }
            ];
        }
      ];
    };
    security.doas = mkIf (sudo_doas == "doas") {
      extraRules = let
        doasCmdNoPass = cmd: { users = [ "btrbk" ]; cmd = cmd; noPass = true; };
      in
        [
            (doasCmdNoPass "${pkgs.btrfs-progs}/bin/btrfs")
            (doasCmdNoPass "${pkgs.coreutils}/bin/mkdir")
            (doasCmdNoPass "${pkgs.coreutils}/bin/readlink")
            # for ssh, they are not the same than the one hard coded in ${pkgs.btrbk}
            (doasCmdNoPass "/run/current-system/bin/btrfs")
            (doasCmdNoPass "/run/current-system/sw/bin/mkdir")
            (doasCmdNoPass "/run/current-system/sw/bin/readlink")

            # doas matches command, not binary
            (doasCmdNoPass "btrfs")
            (doasCmdNoPass "mkdir")
            (doasCmdNoPass "readlink")
        ];
    };
    users.users.btrbk = {
      isSystemUser = true;
      # ssh needs a home directory
      home = "/var/lib/btrbk";
      createHome = true;
      shell = "${pkgs.bash}/bin/bash";
      group = "btrbk";
      openssh.authorizedKeys.keys = map
        (
          v:
          let
            options = concatMapStringsSep " " (x: "--" + x) v.roles;
            ioniceClass = {
              "idle" = 3;
              "best-effort" = 2;
              "realtime" = 1;
            }.${cfg.ioSchedulingClass};
            sudo_doas_flag = "--${sudo_doas}";
          in
          ''command="${pkgs.util-linux}/bin/ionice -t -c ${toString ioniceClass} ${optionalString (cfg.niceness >= 1) "${pkgs.coreutils}/bin/nice -n ${toString cfg.niceness}"} ${pkgs.btrbk}/share/btrbk/scripts/ssh_filter_btrbk.sh ${sudo_doas_flag} ${options}" ${v.key}''
        )
        cfg.sshAccess;
    };
    users.groups.btrbk = { };
    systemd.tmpfiles.rules = [
      "d /var/lib/btrbk 0750 btrbk btrbk"
      "d /var/lib/btrbk/.ssh 0700 btrbk btrbk"
      "f /var/lib/btrbk/.ssh/config 0700 btrbk btrbk - StrictHostKeyChecking=accept-new"
    ];
    environment.etc = mapAttrs'
      (
        name: instance: {
          name = "btrbk/${name}.conf";
          value.source = mkConfigFile name instance.settings;
        }
      )
      cfg.instances;
    systemd.services = mapAttrs'
      (
        name: _: {
          name = "btrbk-${name}";
          value = {
            description = "Takes BTRFS snapshots and maintains retention policies.";
            unitConfig.Documentation = "man:btrbk(1)";
            path = [ "/run/wrappers" ] ++ cfg.extraPackages;
            serviceConfig = {
              User = "btrbk";
              Group = "btrbk";
              Type = "oneshot";
              ExecStart = "${pkgs.btrbk}/bin/btrbk -c /etc/btrbk/${name}.conf run";
              Nice = cfg.niceness;
              IOSchedulingClass = cfg.ioSchedulingClass;
              StateDirectory = "btrbk";
            };
          };
        }
      )
      cfg.instances;

    systemd.timers = mapAttrs'
      (
        name: instance: {
          name = "btrbk-${name}";
          value = {
            description = "Timer to take BTRFS snapshots and maintain retention policies.";
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = instance.onCalendar;
              AccuracySec = "10min";
              Persistent = true;
            };
          };
        }
      )
      (filterAttrs (name: instance: instance.onCalendar != null)
        cfg.instances);
  };

}

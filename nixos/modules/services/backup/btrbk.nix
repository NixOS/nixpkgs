{ config, pkgs, lib, ... }:
let
  cfg = config.services.btrbk;
  sshEnabled = cfg.sshAccess != [ ];
  serviceEnabled = cfg.instances != { };
  attr2Lines = attr:
    let
      pairs = lib.attrsets.mapAttrsToList (name: value: { inherit name value; }) attr;
      isSubsection = value:
        if builtins.isAttrs value then true
        else if builtins.isString value then false
        else throw "invalid type in btrbk config ${builtins.typeOf value}";
      sortedPairs = lib.lists.partition (x: isSubsection x.value) pairs;
    in
    lib.flatten (
      # non subsections go first
      (
        map (pair: [ "${pair.name} ${pair.value}" ]) sortedPairs.wrong
      )
      ++ # subsections go last
      (
        map
          (
            pair:
            lib.mapAttrsToList
              (
                childname: value:
                  [ "${pair.name} ${childname}" ] ++ (map (x: " " + x) (attr2Lines value))
              )
              pair.value
          )
          sortedPairs.right
      )
    )
  ;
  addDefaults = settings: { backend = "btrfs-progs-sudo"; } // settings;
  mkConfigFile = settings: lib.concatStringsSep "\n" (attr2Lines (addDefaults settings));
  mkTestedConfigFile = name: settings:
    let
      configFile = pkgs.writeText "btrbk-${name}.conf" (mkConfigFile settings);
    in
    pkgs.runCommand "btrbk-${name}-tested.conf" { } ''
      mkdir foo
      cp ${configFile} $out
      if (set +o pipefail; ${pkgs.btrbk}/bin/btrbk -c $out ls foo 2>&1 | grep $out);
      then
      echo btrbk configuration is invalid
      cat $out
      exit 1
      fi;
    '';
in
{
  options = {
    services.btrbk = {
      extraPackages = lib.mkOption {
        description = "Extra packages for btrbk, like compression utilities for <literal>stream_compress</literal>";
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.xz ]";
      };
      niceness = lib.mkOption {
        description = "Niceness for local instances of btrbk. Also applies to remote ones connecting via ssh when positive.";
        type = lib.types.ints.between (-20) 19;
        default = 10;
      };
      ioSchedulingClass = lib.mkOption {
        description = "IO scheduling class for btrbk (see ionice(1) for a quick description). Applies to local instances, and remote ones connecting by ssh if set to idle.";
        type = lib.types.enum [ "idle" "best-effort" "realtime" ];
        default = "best-effort";
      };
      instances = lib.mkOption {
        description = "Set of btrbk instances. The instance named <literal>btrbk</literal> is the default one.";
        type = with lib.types;
          attrsOf (
            submodule {
              options = {
                onCalendar = lib.mkOption {
                  type = lib.types.str;
                  default = "daily";
                  description = "How often this btrbk instance is started. See systemd.time(7) for more information about the format.";
                };
                settings = lib.mkOption {
                  type = let t = lib.types.attrsOf (lib.types.either lib.types.str (t // { description = "instances of this type recursively"; })); in t;
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
                  description = "configuration options for btrbk. Nested attrsets translate to subsections.";
                };
              };
            }
          );
        default = { };
      };
      sshAccess = lib.mkOption {
        description = "SSH keys that should be able to make or push snapshots on this system remotely with btrbk";
        type = with lib.types; listOf (
          submodule {
            options = {
              key = lib.mkOption {
                type = str;
                description = "SSH public key allowed to login as user <literal>btrbk</literal> to run remote backups.";
              };
              roles = lib.mkOption {
                type = listOf (enum [ "info" "source" "target" "delete" "snapshot" "send" "receive" ]);
                example = [ "source" "info" "send" ];
                description = "What actions can be performed with this SSH key. See ssh_filter_btrbk(1) for details";
              };
            };
          }
        );
        default = [ ];
      };
    };

  };
  config = lib.mkIf (sshEnabled || serviceEnabled) {
    environment.systemPackages = [ pkgs.btrbk ] ++ cfg.extraPackages;
    security.sudo.extraRules = [
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
            options = lib.concatMapStringsSep " " (x: "--" + x) v.roles;
            ioniceClass = {
              "idle" = 3;
              "best-effort" = 2;
              "realtime" = 1;
            }.${cfg.ioSchedulingClass};
          in
          ''command="${pkgs.util-linux}/bin/ionice -t -c ${toString ioniceClass} ${lib.optionalString (cfg.niceness >= 1) "${pkgs.coreutils}/bin/nice -n ${toString cfg.niceness}"} ${pkgs.btrbk}/share/btrbk/scripts/ssh_filter_btrbk.sh --sudo ${options}" ${v.key}''
        )
        cfg.sshAccess;
    };
    users.groups.btrbk = { };
    systemd.tmpfiles.rules = [
      "d /var/lib/btrbk 0750 btrbk btrbk"
      "d /var/lib/btrbk/.ssh 0700 btrbk btrbk"
      "f /var/lib/btrbk/.ssh/config 0700 btrbk btrbk - StrictHostKeyChecking=accept-new"
    ];
    environment.etc = lib.mapAttrs'
      (
        name: instance: {
          name = "btrbk/${name}.conf";
          value.source = mkTestedConfigFile name instance.settings;
        }
      )
      cfg.instances;
    systemd.services = lib.mapAttrs'
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

    systemd.timers = lib.mapAttrs'
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
      cfg.instances;
  };

}

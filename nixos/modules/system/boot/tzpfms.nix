{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

# NOTE: the loading of keys is done in separate tzpfms systemd services
# defined below rather than inline in the ZFS import scripts.

let
  cfgZFS = config.boot.zfs;
  cfg = cfgZFS.tzpfms;

  datasetToPool = x: lib.elemAt (lib.splitString "/" x) 0;

  pools = lib.unique (map datasetToPool cfg.datasets);

  # All ZFS filesystems
  zfsFilesystems = lib.filter (x: x.fsType == "zfs") config.system.build.fileSystems;

  # Pools that are already imported in initrd (have neededForBoot filesystems)
  fsToPool = fs: lib.elemAt (lib.splitString "/" fs.device) 0;
  rootPools = lib.unique (map fsToPool (lib.filter utils.fsNeededForBoot zfsFilesystems));

  # Only include initrd resources if datasets belong to pools that need initrd import.
  # A pool needs initrd import if it has neededForBoot filesystems.
  initrdPools = lib.filter (pool: lib.elem pool rootPools) pools;
  systemPools = lib.filter (pool: !(lib.elem pool rootPools)) pools;

  needsInitrd = initrdPools != [ ];

  datasetsByPool = lib.groupBy datasetToPool cfg.datasets;

  # Goup neededForBoot filesystems by pool → initrd mount units
  initrdMountsByPool = lib.foldl' (
    acc: fs:
    let
      p = lib.elemAt (lib.splitString "/" fs.device) 0;
      mount = "${utils.escapeSystemdPath ("/sysroot" + (lib.removeSuffix "/" fs.mountPoint))}.mount";
    in
    if utils.fsNeededForBoot fs then acc // { ${p} = (acc.${p} or [ ]) ++ [ mount ]; } else acc
  ) { } zfsFilesystems;

  # Group all ZFS filesystems by pool → system mount units
  systemMountsByPool = lib.foldl' (
    acc: fs:
    let
      pool = lib.elemAt (lib.splitString "/" fs.device) 0;
      mount = "${utils.escapeSystemdPath (lib.removeSuffix "/" fs.mountPoint)}.mount";
    in
    acc // { ${pool} = (acc.${pool} or [ ]) ++ [ mount ]; }
  ) { } zfsFilesystems;

  # Generate tzpfms key-loading bash script
  mkTzpfmsScript = datasets: /* bash */ ''
    tzpfms_load_key() {
      zfs-tpm-list -H ${backendArgs} "$@" 2>/dev/null | while IFS=$'\t' read -r name backend status _; do
        case "$backend" in
          ${lib.optionalString (lib.elem "TPM2" cfg.backends) /* bash */ ''
            TPM2)
              zfs-tpm2-load-key "$name" || true
              ;;
          ''}
          ${lib.optionalString (lib.elem "TPM1.X" cfg.backends) /* bash */ ''
            TPM1.X)
              zfs-tpm1x-load-key "$name" || true
              ;;
          ''}
          *)
            echo "[WARN] boot.zfs.tzpfms: Unsupported tzpfms backend: “$backend”; “$name” not unlocked" >&2
            ;;
        esac
      done
    }

    ${lib.concatMapStringsSep "\n" (ds: "tzpfms_load_key -u ${lib.escapeShellArg ds}") datasets}
  '';

  mkTzpfmsService =
    {
      pool,
      mountUnits,
      script,
    }:
    {
      description = "Load TPM keys for ZFS pool “${pool}”";
      after = [ "zfs-import-${pool}.service" ];
      before = mountUnits ++ [ "zfs-import.target" ];
      requiredBy = mountUnits ++ [ "zfs-import.target" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      inherit script;
    };

  backendArgs = lib.escapeShellArgs (
    lib.concatMap (b: [
      "-b"
      b
    ]) cfg.backends
  );
in
{
  meta.maintainers = with lib.maintainers; [ toastal ];

  options = {
    boot.zfs.tzpfms = {
      enable = lib.mkEnableOption ''
        TPM-backed ZFS encryption using tzpfms.
        Supports both TPM 2.0 & TPM 1.x.
      '';

      package = lib.mkPackageOption pkgs "tzpfms" { };

      backends = lib.mkOption {
        type =
          with lib.types;
          nonEmptyListOf (enum [
            "TPM2"
            "TPM1.X"
          ]);
        default = [
          "TPM2"
        ];
        description = ''
          TPM backends to include in for tzpfms.
        '';
      };

      datasets = lib.mkOption {
        # Needs to be explicit so we can build thy systemd services
        type = with lib.types; nonEmptyListOf str;
        example = [
          "tank/root"
          "tank/var"
        ];
        description = ''
          Explicit list of ZFS datasets to unlock with TPM at boot.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          config.boot.supportedFilesystems.zfs or config.boot.initrd.supportedFilesystems.zfs or false;
        message = "ZFS filesystem support needs to be enabled for boot.tzpfms to work";
      }
      {
        assertion = initrdPools != { } -> config.boot.initrd.systemd.enable;
        message = "boot.zfs.tzpfms requires boot.initrd.systemd.enable = true";
      }
      {
        assertion =
          !(cfgZFS.requestEncryptionCredentials == true) || cfgZFS.requestEncryptionCredentials == [ ];
        message = ''
          boot.zfs.requestEncryptionCredentials = true would prompt for all
          encrypted dataset passphrases at boot, which conflicts with automatic
          TPM unlock via tzpfms. Either set it to false, or explicitly list the
          datasets that still need passphrase prompting.
        '';
      }
      (
        let
          intersected = lib.intersectLists cfg.datasets (
            if lib.isList cfgZFS.requestEncryptionCredentials then cfgZFS.requestEncryptionCredentials else [ ]
          );
        in
        {
          assertion = builtins.length intersected == 0;
          message = ''
            The following datasets are listed in both boot.zfs.tzpfms.datasets
            & boot.zfs.requestEncryptionCredentials, which would cause a
            passphrase prompt to block boot before tzpfms can unlock them via
            TPM:

            ${lib.concatMapStringsSep "\n" (d: "• ${d}") intersected}

            Remove them from boot.zfs.requestEncryptionCredentials to allow
            automatic TPM unlock.
          '';
        }
      )
    ];

    environment.systemPackages = [ cfg.package ];

    # Automatically register pools from tzpfms datasets as extraPools
    boot.zfs.extraPools = pools;

    boot.initrd = lib.mkMerge [
      (lib.mkIf cfg.enable {
        availableKernelModules = [
          "tpm_tis"
          "tpm_crb"
        ];
      })
      (lib.mkIf needsInitrd (
        lib.mkMerge [
          (lib.mkIf config.boot.initrd.systemd.enable {
            systemd.extraBin = {
              zfs-tpm-list = "${lib.getBin cfg.package}/bin/zfs-tpm-list";
            }
            // lib.optionalAttrs (lib.elem "TPM2" cfg.backends) {
              zfs-tpm2-load-key = "${lib.getBin cfg.package}/bin/zfs-tpm2-load-key";
            }
            // lib.optionalAttrs (lib.elem "TPM1.X" cfg.backends) {
              zfs-tpm1x-load-key = "${lib.getBin cfg.package}/bin/zfs-tpm1x-load-key";
            };
            systemd.storePaths =
              lib.optional (lib.elem "TPM2" cfg.backends) pkgs.tpm2-tss
              ++ lib.optional (lib.elem "TPM1.X" cfg.backends) pkgs.trousers;
            systemd.services = lib.genAttrs' initrdPools (pool: {
              name = "tzpfms-load-${pool}";
              value = mkTzpfmsService {
                inherit pool;
                mountUnits = initrdMountsByPool.${pool} or [ ];
                script = mkTzpfmsScript (datasetsByPool.${pool} or [ ]);
              };
            });
          })
        ]
      ))
    ];

    systemd.services = lib.genAttrs' systemPools (
      pool:
      let
        mnts = systemMountsByPool.${pool} or [ ];
      in
      {
        name = "tzpfms-load-${pool}";
        value = mkTzpfmsService {
          inherit pool;
          mountUnits = mnts;
          script = mkTzpfmsScript (datasetsByPool.${pool} or [ ]);
        };
      }
    );
  };
}

{ config, lib, pkgs, ... }:
let
  types = lib.types;
in
{
  options.boot.stratis = {
    rootPoolUuid = lib.mkOption {
      type = types.uniq (types.nullOr types.str);
      description = lib.mdDoc ''
        UUID of the stratis pool that the root fs is located in
      '';
      example = "04c68063-90a5-4235-b9dd-6180098a20d9";
      default = null;
    };
  };
  config = lib.mkIf (config.boot.stratis.rootPoolUuid != null) {
    assertions = [
      {
        assertion = config.boot.initrd.systemd.enable;
        message = "stratis root fs requires systemd stage 1";
      }
    ];
    boot.initrd = {
      systemd = {
        storePaths = [
          "${pkgs.stratisd}/lib/udev/stratis-base32-decode"
          "${pkgs.stratisd}/lib/udev/stratis-str-cmp"
          "${pkgs.lvm2.bin}/bin/dmsetup"
          "${pkgs.stratisd}/libexec/stratisd-min"
          "${pkgs.stratisd.initrd}/bin/stratis-rootfs-setup"
        ];
        packages = [pkgs.stratisd.initrd];
        extraBin = {
          thin_check = "${pkgs."thin-provisioning-tools"}/bin/thin_check";
          thin_repair = "${pkgs."thin-provisioning-tools"}/bin/thin_repair";
          thin_metadata_size = "${pkgs."thin-provisioning-tools"}/bin/thin_metadata_size";
          stratis-min = "${pkgs.stratisd}/bin/stratis-min";
        };
        services = {
          stratis-setup = {
            description = "setup for Stratis root filesystem";
            unitConfig.DefaultDependencies = "no";
            conflicts = [ "shutdown.target" "initrd-switch-root.target" ];
            onFailure = [ "emergency.target" ];
            unitConfig.OnFailureJobMode = "isolate";
            wants = [ "stratisd-min.service" "plymouth-start.service" ];
            wantedBy = [ "initrd.target" ];
            after = [ "paths.target" "plymouth-start.service" "stratisd-min.service" ];
            before = [ "initrd.target" "shutdown.target" "initrd-switch-root.target" ];
            environment.STRATIS_ROOTFS_UUID = config.boot.stratis.rootPoolUuid;
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.stratisd.initrd}/bin/stratis-rootfs-setup";
              RemainAfterExit = "yes";
            };
          };
        };
      };
      availableKernelModules = [ "dm-thin-pool" "dm-crypt" ] ++ [ "aes" "aes_generic" "blowfish" "twofish"
        "serpent" "cbc" "xts" "lrw" "sha1" "sha256" "sha512"
        "af_alg" "algif_skcipher"
      ];
      services.udev.packages = [
        pkgs.stratisd.initrd
        pkgs.lvm2
      ];
    };
  };
}

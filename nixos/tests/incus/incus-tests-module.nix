{ config, lib, ... }:
let
  cfg = config.tests.incus;
in
{
  options.tests.incus = {
    lts = lib.mkEnableOption "LTS package testing";

    all = lib.mkEnableOption "All tests";
    appArmor = lib.mkEnableOption "AppArmor during tests";

    feature.user = lib.mkEnableOption "Validate incus user access feature";

    init = {
      legacy = lib.mkEnableOption "Validate non-systemd init";
      systemd = lib.mkEnableOption "Validate systemd init";
    };

    instance = {
      container = lib.mkEnableOption "Validate container functionality";
      virtual-machine = lib.mkEnableOption "Validate virtual machine functionality";
    };

    network.ovs = lib.mkEnableOption "Validate OVS network integration";

    storage = {
      lvm = lib.mkEnableOption "Validate LVM storage integration";
      zfs = lib.mkEnableOption "Validate ZFS storage integration";
    };
  };

  config = {
    tests.incus = {
      lts = lib.mkDefault true;

      feature.user = lib.mkDefault cfg.all;

      init = {
        legacy = lib.mkDefault cfg.all;
        systemd = lib.mkDefault true;
      };

      instance = {
        container = lib.mkDefault cfg.all;
        virtual-machine = lib.mkDefault cfg.all;
      };

      network.ovs = lib.mkDefault cfg.all;

      storage = {
        lvm = lib.mkDefault cfg.all;
        zfs = lib.mkDefault cfg.all;
      };
    };
  };
}

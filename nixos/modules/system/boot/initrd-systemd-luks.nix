{ lib, pkgs, config, ... }:
with lib;
let
  systemd = config.boot.initrd.systemd.package;
  crypttab =
    let
      luksDevices = attrValues config.boot.initrd.luks.devices;
      stringifyLuksDevice = { name, device, header, keyFile, keyFileSize, keyFileOffset, allowDiscards, ... }@fs:
        let
          opts =
            optional allowDiscards "discard" ++
            optional (keyFileOffset != null) "keyfile-offset=${keyFileOffset}" ++
            optional (keyFileSize != null) "keyfile-size=${keyFileSize}" ++
            optional (header != null) "header=${header}";
          optsSection = lib.concatStringsSep "," opts;
          keyFileSection = if keyFile == null then "-" else keyFile;
        in
        "${name} ${device} ${keyFileSection} ${optsSection}";
    in
    lib.concatMapStringsSep "\n" stringifyLuksDevice luksDevices;
in
{
  config = {
    boot.initrd.availableKernelModules =
      [ "dm_mod" "dm_crypt" "cryptd" "input_leds" ]
      ++ config.boot.initrd.luks.cryptoModules ++ [
        "ecb"
      ];

    boot.initrd.systemd = {
      additionalUpstreamUnits = [
        "cryptsetup-pre.target"
        "cryptsetup.target"
        "remote-cryptsetup.target"
      ];

      initrdBin = [
        pkgs.cryptsetup
      ];

      contents = {
        "/etc/crypttab".text = crypttab;
      };

      storePaths = [
        "${systemd}/lib/systemd/systemd-cryptsetup"
      ];
    };
  };
}

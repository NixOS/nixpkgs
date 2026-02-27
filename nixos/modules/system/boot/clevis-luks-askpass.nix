{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.boot.initrd.clevisLuksAskpass;
in
{
  options = {
    boot.initrd.clevisLuksAskpass.enable = lib.mkEnableOption ''
      clevis-luks-askpass in initrd.

      Watches for systemd password requests during boot and answers them
      using clevis tokens bound to LUKS headers. Runs in parallel with
      the interactive password prompt. If clevis cannot unlock a device
      (tang unreachable, no binding, etc.) the user can still type the
      passphrase.

      Prerequisites:
      - Bind clevis to each LUKS device:
          clevis luks bind -d /dev/xxx tang '{"url":"..."}'
      - Configure networking in the initrd so tang servers are reachable
    '';

    boot.initrd.clevisLuksAskpass.package = lib.mkPackageOption pkgs "clevis" { };

    boot.initrd.clevisLuksAskpass.useTang = lib.mkOption {
      description = "Whether the Clevis headers used to decrypt the devices uses a Tang server as a pin.";
      default = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.boot.initrd.systemd.enable;
        message = "clevis-luks-askpass requires boot.initrd.systemd.enable = true";
      }
    ];

    warnings =
      if
        cfg.useTang && !config.boot.initrd.network.enable && !config.boot.initrd.systemd.network.enable
      then
        [ "In order to use a Tang pinned secret you must configure networking in initrd" ]
      else
        [ ];

    boot.initrd.systemd = {
      # Install upstream clevis-luks-askpass.path and clevis-luks-askpass.service into the initrd
      packages = [ cfg.package ];

      storePaths = [
        cfg.package
        "${pkgs.systemd}/lib/systemd/systemd-reply-password"
        "${pkgs.jose}/bin/jose"
        "${pkgs.curl}/bin/curl"
        "${pkgs.cryptsetup}/bin/cryptsetup"
        "${pkgs.gnused}/bin/sed"
        "${pkgs.gnugrep}/bin/grep"
        "${pkgs.gawk}/bin/gawk"
        "${pkgs.coreutils}/bin/cat"
        "${pkgs.luksmeta}/bin/luksmeta"
        "${pkgs.tpm2-tools}/bin/tpm2_createprimary"
        "${pkgs.tpm2-tools}/bin/tpm2_flushcontext"
        "${pkgs.tpm2-tools}/bin/tpm2_load"
        "${pkgs.tpm2-tools}/bin/tpm2_unseal"
      ];

      # This is in the [Install] section of clevis-luks-askpass.path but that's not processed in nixos so we add it here
      paths.clevis-luks-askpass = {
        wantedBy = [ "cryptsetup.target" ];
      };

      services.clevis-luks-askpass = {
        wants = lib.optional cfg.useTang "network-online.target";
        after = lib.optional cfg.useTang "network-online.target";
      };
    };
  };
}

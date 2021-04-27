{ config, lib, pkgs, ... }:

with lib;

# https://www.gnupg.org/howtos/card-howto/en/gnupg-ccid.rules
# https://www.gnupg.org/howtos/card-howto/en/gnupg-ccid

let
  cfg = config.hardware.gnupg-ccid;

  # TODO: where the g-p-fuck-sticks is "gnupg-ccid.usermap" meant to come from

  scardGroup = "scard";

  gnupgRulesPkg = pkgs.writeTextDir "lib/udev/rules.d/gnupg-ccid.rules" ''
    ACTION=="add", SUBSYSTEM=="usb", ENV{PRODUCT}=="4e6/e003/*", RUN+="${gnupgCcidScript}"
    ACTION=="add", SUBSYSTEM=="usb", ENV{PRODUCT}=="4e6/5115/*", RUN+="${gnupgCcidScript}"
  '';

  gnupgCcidScript = pkgs.writeShellScript "gnupg-ccid" ''
    GROUP="${scardGroup}"

    if [ "${ACTION}" = "add" ] && [ -f "${DEVICE}" ]; then
      ${pkgs.coreutils}/bin/chmod o-rwx "${DEVICE}"
      ${pkgs.coreutils}/bin/chgrp "${GROUP}" "${DEVICE}"
      ${pkgs.coreutils}/bin/chmod g+rw "${DEVICE}"
    fi
  '';
in {
  options.hardware.gnupg-ccid = {
    enable = mkEnableOption "udev rules for Ledger devices";
    group = mkOption {
      description = "the name of the group to receive permission to smart cards";
      type = pkgs.types.str;
      default = "scard";
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ gnupgRulesPkg ];
  };
}

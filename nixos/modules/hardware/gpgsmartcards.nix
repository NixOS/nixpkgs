{ config, lib, pkgs, ... }:

with lib;
let
  # gnupg's manual describes how to setup ccid udev rules:
  #   https://www.gnupg.org/howtos/card-howto/en/ch02s03.html
  # gnupg folks advised me (https://dev.gnupg.org/T5409) to look at debian's rules:
  # https://salsa.debian.org/debian/gnupg2/-/blob/debian/main/debian/scdaemon.udev

  # the latest rev of the entire debian gnupg2 repo as of 2021-04-28
  # the scdaemon.udev file was last commited on 2021-01-05 (7817a03):
  scdaemonUdevRev = "01898735a015541e3ffb43c7245ac1e612f40836";

  scdaemonRules = pkgs.fetchurl {
    url = "https://salsa.debian.org/debian/gnupg2/-/raw/${scdaemonUdevRev}/debian/scdaemon.udev";
    sha256 = "08v0vp6950bz7galvc92zdss89y9vcwbinmbfcdldy8x72w6rqr3";
  };

  # per debian's udev deb hook (https://man7.org/linux/man-pages/man1/dh_installudev.1.html)
  destination = "60-scdaemon.rules";

  scdaemonUdevRulesPkg = pkgs.runCommand "scdaemon-udev-rules" {} ''
    loc="$out/lib/udev/rules.d/"
    mkdir -p "''${loc}"
    cp "${scdaemonRules}" "''${loc}/${destination}"
  '';

  cfg = config.hardware.gpgSmartcards;
in {
  options.hardware.gpgSmartcards = {
    enable = mkEnableOption (lib.mdDoc "udev rules for gnupg smart cards");
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ scdaemonUdevRulesPkg ];
  };
}

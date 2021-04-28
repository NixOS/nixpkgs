{ config, lib, pkgs, ... }:

with lib;

# https://www.gnupg.org/howtos/card-howto/en/gnupg-ccid.rules
# https://www.gnupg.org/howtos/card-howto/en/gnupg-ccid

# but then: https://dev.gnupg.org/T5409
# https://salsa.debian.org/debian/gnupg2/-/blob/debian/main/debian/scdaemon.udev

# per https://man7.org/linux/man-pages/man1/dh_installudev.1.html
# it looks like the default level prefix is 60-...

let
  # from: https://salsa.debian.org/debian/gnupg2/-/blob/debian/main/debian/scdaemon.udev
  # latest available on 2021-04-28 (file last commited on 2021-01-05 7817a03).
  scdaemonUdevRev = "01898735a015541e3ffb43c7245ac1e612f40836";

  scdaemonRules = builtins.fetchurl {
    url = "https://salsa.debian.org/debian/gnupg2/-/raw/${scdaemonUdevRev}/debian/scdaemon.udev";
    sha256 = "08v0vp6950bz7galvc92zdss89y9vcwbinmbfcdldy8x72w6rqr3";
  };

  scdaemonUdevRulesPkg = pkgs.runCommandNoCC "scdaemon-udev-rules" {} ''
    loc="$out/lib/udev/rules.d/"
    mkdir -p "''${loc}"
    cp "${scdaemonRules}" "''${loc}/60-scdaemon.rules"
  '';

  cfg = config.hardware.gpgSmartcards;
in {
  options.hardware.gpgSmartcards = {
    enable = mkEnableOption "udev rules for gnupg smart cards";
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ scdaemonUdevRulesPkg ];
  };
}

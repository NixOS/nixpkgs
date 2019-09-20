{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.ledger;

  ledger-rules = pkgs.stdenv.mkDerivation {
    pname = "ledger-udev-rules";
    version = "unstable-2019-02-13";

    src = pkgs.fetchFromGitHub {
      owner = "LedgerHQ";
      repo = "udev-rules";
      rev = "20cc1651eb551c4855aaa56628c77eaeb3031c22";
      sha256 = "0riydkc4in10pv4qlrvbg3w78qsvxly5caa3zwyqcmsm5fmprqky";
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      mkdir -p $out/lib/udev/rules.d
      cp 20-hw1.rules $out/lib/udev/rules.d/20-ledger.rules
    '';

    meta = with pkgs.stdenv.lib; {
      description = "udev rules for Ledger devices";
      license = licenses.asl20;
      maintainers = with maintainers; [ asymmetric ];
      platforms = platforms.linux;
      homepage = https://github.com/LedgerHQ/udev-rules;
    };
  };

in {
  options.hardware.ledger.enable = mkEnableOption "udev rules for Ledger devices";

  config = mkIf cfg.enable {
    services.udev.packages = [ ledger-rules ];
  };
}

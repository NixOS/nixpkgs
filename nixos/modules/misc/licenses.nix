{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.nixpkgs.licenses;

  accept = x: x == "accept";

in

{
  options = {

    nixpkgs.licenses = {

      allowUnfree = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Allow all unfree licenses. If false packages with an
          unfree license cannot be installed from nixpkgs.
        '';
      };

      oracleBinaryCodeLicenseForJava = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Say "accept" if you accept the:

          Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX
 
          The full license text is at:
          http://www.oracle.com/technetwork/java/javase/terms/license/index.html
        '';
      };

    };

  };


  config = {

    nixpkgs.config = {

      allowUnfree = cfg.allowUnfree;

      blacklistedLicenses = []
        ++ lib.optional (!accept cfg.oracleBinaryCodeLicenseForJava) lib.licenses.oraclejavabcl;

    };

  };

}

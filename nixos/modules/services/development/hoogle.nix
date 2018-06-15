{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.hoogle;

  hoogleEnv = pkgs.buildEnv {
    name = "hoogle";
    paths = [ (cfg.haskellPackages.ghcWithHoogle cfg.packages) ];
  };

in {

  options.services.hoogle = {
    enable = mkEnableOption "Haskell documentation server";

    port = mkOption {
      type = types.int;
      default = 8080;
      description = ''
        Port number Hoogle will be listening to.
      '';
    };

    packages = mkOption {
      default = hp: [];
      defaultText = "hp: []";
      example = "hp: with hp; [ text lens ]";
      description = ''
        The Haskell packages to generate documentation for.

        The option value is a function that takes the package set specified in
        the <varname>haskellPackages</varname> option as its sole parameter and
        returns a list of packages.
      '';
    };

    haskellPackages = mkOption {
      description = "Which haskell package set to use.";
      default = pkgs.haskellPackages;
      defaultText = "pkgs.haskellPackages";
    };

  };

  config = mkIf cfg.enable {
    systemd.services.hoogle = {
      description = "Haskell documentation server";

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Restart = "always";
        ExecStart = ''${hoogleEnv}/bin/hoogle server --local -p ${toString cfg.port}'';

        User = "nobody";
        Group = "nogroup";

        PrivateTmp = true;
        ProtectHome = true;

        RuntimeDirectory = "hoogle";
        WorkingDirectory = "%t/hoogle";
      };
    };
  };

}

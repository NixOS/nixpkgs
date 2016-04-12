{ config, lib, pkgs, ... }:

# services.hoogle = {
#   enable = true;
#   packages = hp: with hp; [ text lens ];
#   haskellPackages = pkgs.haskellPackages;
# };

with lib;

let

  cfg = config.services.hoogle;
  ghcWithHoogle = pkgs.haskellPackages.ghcWithHoogle;

in {

  options.services.hoogle = {
    enable = mkEnableOption "Hoogle Documentation service";

    port = mkOption {
      type = types.int;
      default = 8080;
      description = ''
        Port number Hoogle will be listening to.
      '';
    };

    packages = mkOption {
      default = hp: [];
      example = "hp: with hp; [ text lens ]";
      description = ''
        A function that returns a list of Haskell packages to generate
        documentation for.

        The argument will be a Haskell package set provided by the
        haskellPackages config option.
      '';
    };

    haskellPackages = mkOption {
      description = "Which haskell package set to use.";
      example = "pkgs.haskellPackages";
      type = types.attrs;
    };

  };

  config = mkIf cfg.enable {
    systemd.services.hoogle = {
      description = "Hoogle Haskell documentation search";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "always";
        ExecStart =
          let env = cfg.haskellPackages.ghcWithHoogle cfg.packages;
              hoogleEnv = pkgs.buildEnv {
                name = "hoogleServiceEnv";
                paths = [env];
              };
          in ''
            ${hoogleEnv}/bin/hoogle server --local -p ${toString cfg.port}
          '';
      };
    };
  };

}

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
    enable = mkEnableOption (lib.mdDoc "Haskell documentation server");

    port = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc ''
        Port number Hoogle will be listening to.
      '';
    };

    packages = mkOption {
      type = types.functionTo (types.listOf types.package);
      default = hp: [];
      defaultText = literalExpression "hp: []";
      example = literalExpression "hp: with hp; [ text lens ]";
      description = lib.mdDoc ''
        The Haskell packages to generate documentation for.

        The option value is a function that takes the package set specified in
        the {var}`haskellPackages` option as its sole parameter and
        returns a list of packages.
      '';
    };

    haskellPackages = mkOption {
      description = lib.mdDoc "Which haskell package set to use.";
      type = types.attrs;
      default = pkgs.haskellPackages;
      defaultText = literalExpression "pkgs.haskellPackages";
    };

    home = mkOption {
      type = types.str;
      description = lib.mdDoc "Url for hoogle logo";
      default = "https://hoogle.haskell.org";
    };

    host = mkOption {
      type = types.str;
      description = lib.mdDoc "Set the host to bind on.";
      default = "127.0.0.1";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.hoogle = {
      description = "Haskell documentation server";

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Restart = "always";
        ExecStart = ''${hoogleEnv}/bin/hoogle server --local --port ${toString cfg.port} --home ${cfg.home} --host ${cfg.host}'';

        DynamicUser = true;

        ProtectHome = true;

        RuntimeDirectory = "hoogle";
        WorkingDirectory = "%t/hoogle";
      };
    };
  };

}

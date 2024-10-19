{ config, lib, pkgs, ... }:
let

  cfg = config.services.hoogle;

  hoogleEnv = pkgs.buildEnv {
    name = "hoogle";
    paths = [ (cfg.haskellPackages.ghcWithHoogle cfg.packages) ];
  };

in {

  options.services.hoogle = {
    enable = lib.mkEnableOption "Haskell documentation server";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = ''
        Port number Hoogle will be listening to.
      '';
    };

    packages = lib.mkOption {
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = hp: [];
      defaultText = lib.literalExpression "hp: []";
      example = lib.literalExpression "hp: with hp; [ text lens ]";
      description = ''
        The Haskell packages to generate documentation for.

        The option value is a function that takes the package set specified in
        the {var}`haskellPackages` option as its sole parameter and
        returns a list of packages.
      '';
    };

    haskellPackages = lib.mkOption {
      description = "Which haskell package set to use.";
      type = lib.types.attrs;
      default = pkgs.haskellPackages;
      defaultText = lib.literalExpression "pkgs.haskellPackages";
    };

    home = lib.mkOption {
      type = lib.types.str;
      description = "Url for hoogle logo";
      default = "https://hoogle.haskell.org";
    };

    host = lib.mkOption {
      type = lib.types.str;
      description = "Set the host to bind on.";
      default = "127.0.0.1";
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = [ "--no-security-headers" ];
      description = ''
        Additional command-line arguments to pass to
        {command}`hoogle server`
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.hoogle = {
      description = "Haskell documentation server";

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Restart = "always";
        ExecStart = ''
          ${hoogleEnv}/bin/hoogle server --local --port ${toString cfg.port} --home ${cfg.home} --host ${cfg.host} \
            ${lib.concatStringsSep " " cfg.extraOptions}
        '';

        DynamicUser = true;

        ProtectHome = true;

        RuntimeDirectory = "hoogle";
        WorkingDirectory = "%t/hoogle";
      };
    };
  };

}

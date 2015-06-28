{ pkgs, lib, config, ... }:

with lib;

let

  cfg = config.services.ihaskell;
  ihaskell = pkgs.ihaskell.override {
    inherit (cfg.haskellPackages) ihaskell ghcWithPackages;
    packages = self: cfg.extraPackages self;
  };

in

{
  options = {
    services.ihaskell = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Autostart an IHaskell notebook service.";
      };

      haskellPackages = mkOption {
        default = pkgs.haskellngPackages;
        defaultText = "pkgs.haskellngPackages";
        example = literalExample "pkgs.haskell-ng.packages.ghc784";
        description = ''
          haskellPackages used to build IHaskell and other packages.
          This can be used to change the GHC version used to build
          IHaskell and the packages listed in
          <varname>extraPackages</varname>.
        '';
      };

      extraPackages = mkOption {
        default = self: [];
        example = literalExample ''
          haskellPackages: [
            haskellPackages.wreq
            haskellPackages.lens
          ]
        '';
        description = ''
          Extra packages available to ghc when running ihaskell. The
          value must be a function which receives the attrset defined
          in <varname>haskellPackages</varname> as the sole argument.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    users.extraUsers.ihaskell = {
      group = config.users.extraGroups.ihaskell.name;
      description = "IHaskell user";
      home = "/var/lib/ihaskell";
      createHome = true;
      uid = config.ids.uids.ihaskell;
    };

    users.extraGroups.ihaskell.gid = config.ids.gids.ihaskell;

    systemd.services.ihaskell = {
      description = "IHaskell notebook instance";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = config.users.extraUsers.ihaskell.name;
        Group = config.users.extraGroups.ihaskell.name;
        ExecStart = "${pkgs.stdenv.shell} -c \"cd $HOME;${ihaskell}/bin/ihaskell-notebook\"";
      };
    };
  };
}

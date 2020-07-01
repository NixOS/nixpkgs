{ pkgs, lib, config, ... }:

with lib;

let

  cfg = config.services.ihaskell;
  ihaskell = pkgs.ihaskell.override {
    packages = self: cfg.extraPackages self;
  };

in

{
  options = {
    services.ihaskell = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Autostart an IHaskell notebook service.";
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

    users.users.ihaskell = {
      group = config.users.groups.ihaskell.name;
      description = "IHaskell user";
      home = "/var/lib/ihaskell";
      createHome = true;
      uid = config.ids.uids.ihaskell;
    };

    users.groups.ihaskell.gid = config.ids.gids.ihaskell;

    systemd.services.ihaskell = {
      description = "IHaskell notebook instance";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = config.users.users.ihaskell.name;
        Group = config.users.groups.ihaskell.name;
        ExecStart = "${pkgs.runtimeShell} -c \"cd $HOME;${ihaskell}/bin/ihaskell-notebook\"";
      };
    };
  };
}

let
  pkgs = import ../../.. { };

  configA = pkgs.writeText "configA.nix" ''
    { config, pkgs, ... }: {
      services.configA.enable = true;
      networking.hostName = "example";
      environment.systemPackages = with pkgs; [ hello ];
    }
  '';

  configB = pkgs.writeText "configB.nix" ''
    { config, pkgs, ... }: {
      services.configB.enable = true;
    }
  '';

  configC = pkgs.writeText "configC.nix" ''
    { config, pkgs, ... }: {
      services.configC.enable = true;
    }
  '';

  configBroken = pkgs.writeText "configBroken.nix" ''
    { config, pkgs, ... }: {
      services.configBroken.enable =
    }
  '';
in
{
  none = pkgs.mergeNixOSModules {
    name = "merge-none.nix";
    moduleFiles = [ ];
  };

  one = pkgs.mergeNixOSModules {
    name = "merge-one.nix";
    moduleFiles = [ configA ];
  };

  many = pkgs.mergeNixOSModules {
    name = "merge-many.nix";
    moduleFiles = [ configA configB configC configC configC ];
  };

  broken = pkgs.mergeNixOSModules {
    name = "merge-broken.nix";
    moduleFiles = [ configA configB configC configBroken configBroken ];
  };
}


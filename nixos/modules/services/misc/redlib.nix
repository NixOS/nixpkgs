{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkAliasOptionModule
    mkEnableOption
    mkIf
    mkOption
    mkRenamedOptionModule
    types
    ;

  cfg = config.services.redlib;
in
{
  imports = [
    (mkRenamedOptionModule
      [
        "services"
        "libreddit"
      ]
      [
        "services"
        "redlib"
      ]
    )
  ]
  ++
    map
      (
        opt:
        mkAliasOptionModule
          [
            "services"
            "redlib"
            opt
          ]
          [
            "system"
            "services"
            "redlib"
            "redlib"
            opt
          ]
      )
      [
        "package"
        "address"
        "port"
        "settings"
      ];

  options = {
    services.redlib = {
      enable = mkEnableOption "Private front-end for Reddit";

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the redlib web interface";
      };
    };
  };

  config = mkIf cfg.enable {
    system.services.redlib = {
      imports = [ pkgs.redlib.services.default ];
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ Guanran928 ];
  };
}

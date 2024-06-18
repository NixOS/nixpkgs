{ config, lib, pkgs, ... }:

let
  inherit (lib) optionals mkOption mkEnableOption types mkIf elem concatStringsSep maintainers;
  cfg = config.networking.stevenblack;

  # needs to be in a specific order
  activatedHosts = with cfg; [ ]
    ++ optionals (elem "fakenews" block) [ "fakenews" ]
    ++ optionals (elem "gambling" block) [ "gambling" ]
    ++ optionals (elem "porn" block) [ "porn" ]
    ++ optionals (elem "social" block) [ "social" ];

  hostsPath = "${pkgs.stevenblack-blocklist}/alternates/" + concatStringsSep "-" activatedHosts + "/hosts";
in
{
  options.networking.stevenblack = {
    enable = mkEnableOption "the stevenblack hosts file blocklist";

    block = mkOption {
      type = types.listOf (types.enum [ "fakenews" "gambling" "porn" "social" ]);
      default = [ ];
      description = "Additional blocklist extensions.";
    };
  };

  config = mkIf cfg.enable {
    networking.hostFiles = [ ]
      ++ optionals (activatedHosts != [ ]) [ hostsPath ]
      ++ optionals (activatedHosts == [ ]) [ "${pkgs.stevenblack-blocklist}/hosts" ];
  };

  meta.maintainers = [ maintainers.moni maintainers.artturin ];
}

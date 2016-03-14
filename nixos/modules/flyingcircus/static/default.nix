{ lib, ... }:
with lib;
{
  options = {

    flyingcircus.static = mkOption {
      type = types.attrsOf types.attrs;
      default = { };
      description = "Static lookup tables for site-specfic information";
    };

  };

  config = {
    flyingcircus.static.vlans = {
      "1" = "mgm";
      "2" = "fe";
      "3" = "srv";
      "4" = "sto";
      "5" = "ws";
      "6" = "tr";
      "7" = "gue";
      "8" = "stb";
      "14" = "tr2";
      "15" = "gocept";
      "16" = "fe2";
      "17" = "srv2";
      "18" = "tr3";
    };
  };
}

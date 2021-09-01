{ config, lib, pkgs, ... }:

with lib;

let
  interfaces = config.services.wakeonlan.interfaces;

  ethtool = "${pkgs.ethtool}/sbin/ethtool";

  passwordParameter = password : if (password == "") then "" else
    "sopass ${password}";

  methodParameter = {method, password} :
    if method == "magicpacket" then "wol g"
    else if method == "password" then "wol s so ${passwordParameter password}"
    else throw "Wake-On-Lan method not supported";

  line = { interface, method ? "magicpacket", password ? "" }: ''
    ${ethtool} -s ${interface} ${methodParameter {inherit method password;}}
  '';

  concatStrings = foldr (x: y: x + y) "";
  lines = concatStrings (map (l: line l) interfaces);

in
{

  ###### interface

  options = {

    services.wakeonlan.interfaces = mkOption {
      default = [ ];
      type = types.listOf (types.submodule { options = {
        interface = mkOption {
          type = types.str;
          description = "Interface to enable for Wake-On-Lan.";
        };
        method = mkOption {
          type = types.enum [ "magicpacket" "password"];
          description = "Wake-On-Lan method for this interface.";
        };
        password = mkOption {
          type = types.strMatching "[a-fA-F0-9]{2}:([a-fA-F0-9]{2}:){4}[a-fA-F0-9]{2}";
          description = "The password has the shape of six bytes in hexadecimal separated by a colon each.";
        };
      };});
      example = [
        {
          interface = "eth0";
          method = "password";
          password = "00:11:22:33:44:55";
        }
      ];
      description = ''
        Interfaces where to enable Wake-On-LAN, and how. Two methods available:
        "magicpacket" and "password". The password has the shape of six bytes
        in hexadecimal separated by a colon each. For more information,
        check the ethtool manual.
      '';
    };

  };


  ###### implementation

  config.powerManagement.powerUpCommands = lines;

}

{ config, pkgs, ... }:

with pkgs.lib;

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

  concatStrings = fold (x: y: x + y) "";
  lines = concatStrings (map (l: line l) interfaces);

in
{

  ###### interface

  options = {

    services.wakeonlan.interfaces = mkOption {
      default = [ ];
      example = [
        {
          interface = "eth0";
          method = "password";
          password = "00:11:22:33:44:55";
        }
      ];
      description = ''
        Interfaces where to enable Wake-On-LAN, and how. Two methods available:
        "magickey" and "password". The password has the shape of six bytes
        in hexadecimal separated by a colon each. For more information,
        check the ethtool manual.
      '';
    };

  };


  ###### implementation

  config.powerManagement.powerDownCommands = lines;

}

{ config, lib, pkgs, ... }: with lib;


let

  cfg = config;

  fclib = import ../../lib;

  rules = lib.concatMapStringsSep "\n"
    (filename:
       "# Local rules from ${filename}\n" +
       # We try to be helpful to our users by only allowing calls to iptables
       # and comments.
       (lib.concatMapStringsSep "\n"
          (line: assert hasPrefix "#" line ||
                        hasPrefix "iptables" line ||
                        hasPrefix "ip6tables" line ||
                        hasPrefix "ip46tables" line;
                 line)
          (lib.splitString "\n" (readFile filename))) +
       "\n")
    (fclib.files "/etc/local/firewall");

in

{

  config = {

    networking.firewall.extraCommands = mkIf (pathExists /etc/local/firewall)
      ''
      # Custom local rules from /etc/local/firewall
      ${rules}
      '';

    system.activationScripts.firewall-user = ''
      # Enable firewall local configuration snippet place.
      install -d -o root -g service -m 02775 /etc/local/firewall
    '';

  };

}

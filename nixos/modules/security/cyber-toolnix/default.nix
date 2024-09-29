{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  roles = {
    blue = import ./roles/blue.nix { inherit pkgs; };
    bugbounty = import ./roles/bugbounty.nix { inherit pkgs; };
    cracker = import ./roles/cracker.nix { inherit pkgs; };
    dos = import ./roles/dos.nix { inherit pkgs; };
    forensic = import ./roles/forensic.nix { inherit pkgs; };
    malware = import ./roles/malware.nix { inherit pkgs; };
    mobile = import ./roles/mobile.nix { inherit pkgs; };
    network = import ./roles/network.nix { inherit pkgs; };
    osint = import ./roles/osint.nix { inherit pkgs; };
    red = import ./roles/red.nix { inherit pkgs; };
    student = import ./roles/student.nix { inherit pkgs; };
    web = import ./roles/web.nix { inherit pkgs; };
  };
in
{
  options.cyber-toolnix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the cyber-toolnix module to install cyber security tools based on role.";
    };

    role = mkOption {
      type = types.enum [
        "blue"
        "bugbounty"
        "cracker"
        "dos"
        "forensic"
        "malware"
        "mobile"
        "network"
        "osint"
        "red"
        "student"
        "web"
      ];
      default = "student";
      description = "Cyber role to determine which set of tools to install. Options are 'blue', 'bugbounty', 'cracker', 'dos', 'forensic', 'malware', 'mobile', 'network', 'osint', 'red', 'student' or 'web'.";
      example = "student";
    };
  };

  config = mkIf config.cyber-toolnix.enable {
    environment.systemPackages = builtins.getAttr config.cyber-toolnix.role roles;
  };

  meta.maintainers = with maintainers; [ d3vil0p3r ];
}

{ lib, pkgs, ... }:
{
  name = "syncthing-no-settings";
  meta.maintainers = with pkgs.lib.maintainers; [ chkno ];

  containers = {
    a = {
      environment.systemPackages = with pkgs; [
        curl
        libxml2
        syncthing
      ];
      services.syncthing = {
        enable = true;
      };
    };
  };
  # Test that indeed a syncthing-init.service systemd service is not created.
  #
  testScript = # python
    ''
      a.succeed("systemctl list-unit-files | awk '$1 == \"syncthing-init.service\" {exit 1;}'")
    '';
}

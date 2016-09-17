{ config, pkgs, lib, ... }:
with lib;

{
  meta = {
    maintainers = [ maintainers.joachifm ];
    doc = ./hidepid.xml;
  };

  options = {
    security.hideProcessInformation = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Restrict process information to the owning user.
      '';
    };
  };

  config = mkIf config.security.hideProcessInformation {
    users.groups.proc.gid = config.ids.gids.proc;

    boot.specialFileSystems."/proc".options = [ "hidepid=2" "gid=${toString config.ids.gids.proc}" ];
  };
}

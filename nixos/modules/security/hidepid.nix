{ config, lib, ... }:
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
    users.groups.proc.members = [ "polkituser" ];

    boot.specialFileSystems."/proc".options = [ "hidepid=2" "gid=${toString config.ids.gids.proc}" ];
    systemd.services.systemd-logind.serviceConfig.SupplementaryGroups = [ "proc" ];

    # Disable cgroupsv2, which doesn't work with hidepid.
    # https://github.com/NixOS/nixpkgs/pull/104094#issuecomment-729996203
    systemd.enableUnifiedCgroupHierarchy = false;
  };
}

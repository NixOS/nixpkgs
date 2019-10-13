{ config, lib, pkgs, ... }:
with lib; {
  options = {
    networking.namespaces = mkOption {
      default = [];
      type = types.listOf types.str;
      description = ''
        A list of named network namespaces to create.
      '';
    };
  };
  config.systemd.services = builtins.listToAttrs (map (netns: {
    name = "network-namespace-${netns}";
    value = {
      description = "Network Namespace: ${netns}";
      before = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.iproute}/bin/ip netns add ${strings.escapeShellArg netns}";
        ExecStop = "${pkgs.iproute}/bin/ip netns del ${strings.escapeShellArg netns}";
      };
    };
  }) config.networking.namespaces);
}

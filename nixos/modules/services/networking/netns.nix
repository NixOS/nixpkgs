{ pkgs, lib, config, options, ... }:
with lib;
let
  cfg = config.services.netns;
  inherit (config) networking;
  # Escape as required by: https://www.freedesktop.org/software/systemd/man/systemd.unit.html
  escapeUnitName = name:
    lib.concatMapStrings (s: if lib.isList s then "-" else s)
    (builtins.split "[^a-zA-Z0-9_.\\-]+" name);
  systemd = import (pkgs.path + "/nixos/modules/system/boot/systemd-unit-options.nix") { inherit config lib; };
in
{
options.services.netns = {
  namespaces = mkOption {
    description = "network namespaces to create";
    default = {};
    type = types.attrsOf (types.submodule {
      options = {
        nftables = mkOption {
          type = types.lines;
          default = networking.nftables.ruleset;
          defaultText = "config.networking.nftables.ruleset";
          description = ''
            Nftables ruleset within the network namespace.
          '';
        };
        sysctl = options.boot.kernel.sysctl // {
          default = config.boot.kernel.sysctl;
          defaultText = "config.boot.kernel.sysctl";
          description = ''
            sysctl within the network namespace.
          '';
        };
        service = mkOption {
          # Avoid error: The option `services.netns.namespaces.${netns}.service.startLimitIntervalSec' is used but not defined.
          #type = types.submodule [ { options = builtins.removeAttrs systemd.serviceOptions ["startLimitIntervalSec"]; } ];
          type = types.attrs;
          default = {};
          description = ''
            Systemd configuration specific to this netns service.
          '';
        };
      };
    });
  };
};
config = {
  systemd.services = mapAttrs' (name: c:
    nameValuePair "netns-${escapeUnitName name}" (mkMerge [
      { description = mkForce "${name} network namespace";
        before = [ "network.target" ];
        serviceConfig = {
          Type = mkForce "oneshot";
          RemainAfterExit = true;
          PrivateNetwork = true;
          ExecStart = mkForce (pkgs.writeShellScript "netns-start" ''
            test -e /var/run/netns/${escapeShellArg name} ||
            ${pkgs.iproute}/bin/ip netns add ${escapeShellArg name}
          '');
          ExecStartPost =
            # Use --ignore because some keys may no longer exist in that new namespace,
            # like net.ipv6.conf.eth0.addr_gen_mode or net.core.rmem_max
            [''${pkgs.iproute}/bin/ip netns exec ${escapeShellArg name} ${pkgs.procps}/bin/sysctl --ignore -p ${pkgs.writeScript "sysctl"
                (concatStrings (mapAttrsToList (n: v: optionalString (v != null) "${n}=${if v == false then "0" else toString v}\n") c.sysctl))}
            ''] ++
            optional networking.nftables.enable ''
              ${pkgs.iproute}/bin/ip netns exec ${escapeShellArg name} ${pkgs.writeScript "nftables-ruleset" ''
                #!${pkgs.nftables}/bin/nft -f
                flush ruleset
                ${c.nftables}
              ''}
            '';
          ExecStop = mkForce "${pkgs.iproute}/bin/ip netns del ${escapeShellArg name}";
        };
      }
      c.service
    ]
    )) cfg.namespaces;
  meta.maintainers = with lib.maintainers; [ julm ];
};
}

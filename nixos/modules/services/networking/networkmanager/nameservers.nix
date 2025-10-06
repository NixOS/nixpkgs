{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.networkmanager;

  mkNameserverOption =
    {
      docSnippet,
    }:
    lib.mkOption {
      default = [];
      description = ''
        A list of name servers that should be ${docSnippet}
        the ones configured in NetworkManager or received by DHCP.
      '';

      type = lib.types.listOf lib.types.str;
    };

  ns = xs: pkgs.writeText "nameservers" (lib.concatStrings (map (s: "nameserver ${s}\n") xs));

  overrideScript = pkgs.writeShellScript "02overridedns" ''
    PATH="${lib.makeBinPath [
      pkgs.coreutils
      pkgs.gnugrep
      pkgs.gnused
    ]}"

    tmp=$(mktemp)
    sed '/nameserver /d' /etc/resolv.conf > $tmp
    grep 'nameserver ' /etc/resolv.conf | \
      grep -vf ${ns (cfg.appendNameservers ++ cfg.insertNameservers)} > $tmp.ns
    cat $tmp ${ns cfg.insertNameservers} $tmp.ns ${ns cfg.appendNameservers} > /etc/resolv.conf
    rm -f $tmp $tmp.ns
  '';
in
{
  options = {
    networking.networkmanager = {
      appendNameservers = mkNameserverOption {
        docSnippet = "appended to";
      };

      insertNameservers = mkNameserverOption {
        docSnippet = "inserted before";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc = lib.mkIf (cfg.appendNameservers != [] || cfg.insertNameservers != []) {
      "NetworkManager/dispatcher.d/02overridedns".source = overrideScript;
    };

    systemd.services.NetworkManager-dispatcher = {
      restartTriggers = [ overrideScript ];
    };
  };
}

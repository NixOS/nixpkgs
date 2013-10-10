{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.networking.tcpcrypt;

in

{

  ###### interface

  options = {

    networking.tcpcrypt.enable = mkOption {
      default = false;
      description = ''
        Whether to enable opportunistic TCP encryption. If the other end
        speaks Tcpcrypt, then your traffic will be encrypted; otherwise
        it will be sent in clear text. Thus, Tcpcrypt alone provides no
        guarantees -- it is best effort. If, however, a Tcpcrypt
        connection is successful and any attackers that exist are
        passive, then Tcpcrypt guarantees privacy.
      '';
    };
  };

  config = mkIf cfg.enable {

    users.extraUsers = singleton {
      name = "tcpcryptd";
      uid = config.ids.uids.tcpcryptd;
      description = "tcpcrypt daemon user";
    };

    jobs.tcpcrypt = {
      description = "tcpcrypt";

      wantedBy = ["multi-user.target"];
      after = ["network-interfaces.target"];

      path = [ pkgs.iptables pkgs.tcpcrypt pkgs.procps ];

      preStart = ''
        sysctl -n net.ipv4.tcp_ecn >/run/pre-tcpcrypt-ecn-state
        sysctl -w net.ipv4.tcp_ecn=0

        iptables -t raw -N nixos-tcpcrypt
        iptables -t raw -A nixos-tcpcrypt -p tcp -m mark --mark 0x0/0x10 -j NFQUEUE --queue-num 666
        iptables -t raw -I PREROUTING -j nixos-tcpcrypt

        iptables -t mangle -N nixos-tcpcrypt
        iptables -t mangle -A nixos-tcpcrypt -p tcp -m mark --mark 0x0/0x10 -j NFQUEUE --queue-num 666
        iptables -t mangle -I POSTROUTING -j nixos-tcpcrypt
      '';

      exec = "tcpcryptd -x 0x10";

      postStop = ''
        if [ -f /run/pre-tcpcrypt-ecn-state ]; then
          sysctl -w net.ipv4.tcp_ecn=$(cat /run/pre-tcpcrypt-ecn-state)
        fi

        iptables -t mangle -D POSTROUTING -j nixos-tcpcrypt || true
        iptables -t raw -D PREROUTING -j nixos-tcpcrypt || true

        iptables -t raw -F nixos-tcpcrypt || true
        iptables -t raw -X nixos-tcpcrypt || true

        iptables -t mangle -F nixos-tcpcrypt || true
        iptables -t mangle -X nixos-tcpcrypt || true
      '';
    };
  };

}

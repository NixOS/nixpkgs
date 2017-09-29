{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.libreswan;

  libexec = "${pkgs.libreswan}/libexec/ipsec";
  ipsec = "${pkgs.libreswan}/sbin/ipsec";

  trim = chars: str: let
      nonchars = filter (x : !(elem x.value chars))
                  (imap0 (i: v: {ind = i; value = v;}) (stringToCharacters str));
    in
      if length nonchars == 0 then ""
      else substring (head nonchars).ind (add 1 (sub (last nonchars).ind (head nonchars).ind)) str;
  indent = str: concatStrings (concatMap (s: ["  " (trim [" " "\t"] s) "\n"]) (splitString "\n" str));
  configText = indent (toString cfg.configSetup);
  connectionText = concatStrings (mapAttrsToList (n: v: 
    ''
      conn ${n}
      ${indent v}

    '') cfg.connections);
  configFile = pkgs.writeText "ipsec.conf"
    ''
      config setup
      ${configText}
      
      ${connectionText}
    '';

in

{

  ###### interface

  options = {

    services.libreswan = {

      enable = mkEnableOption "libreswan ipsec service";

      configSetup = mkOption {
        type = types.lines;
        default = ''
            protostack=netkey
            nat_traversal=yes
            virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v4:100.64.0.0/10,%v6:fd00::/8,%v6:fe80::/10
        '';
        example = ''
            secretsfile=/root/ipsec.secrets
            protostack=netkey
            nat_traversal=yes
            virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v4:100.64.0.0/10,%v6:fd00::/8,%v6:fe80::/10
        '';
        description = "Options to go in the 'config setup' section of the libreswan ipsec configuration";
      };

      connections = mkOption {
        type = types.attrsOf types.lines;
        default = {};
        example = {
          myconnection = ''
            auto=add
            left=%defaultroute
            leftid=@user

            right=my.vpn.com

            ikev2=no
            ikelifetime=8h
          '';
        };
        description = "A set of connections to define for the libreswan ipsec service";
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.libreswan pkgs.iproute ];

    systemd.services.ipsec = {
      description = "Internet Key Exchange (IKE) Protocol Daemon for IPsec";
      path = [
        "${pkgs.libreswan}"
        "${pkgs.iproute}"
        "${pkgs.procps}"
      ];

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        EnvironmentFile = "-${pkgs.libreswan}/etc/sysconfig/pluto";
        ExecStartPre = [
          "${libexec}/addconn --config ${configFile} --checkconfig"
          "${libexec}/_stackmanager start"
          "${ipsec} --checknss"
          "${ipsec} --checknflog"
        ];
        ExecStart = "${libexec}/pluto --config ${configFile} --nofork \$PLUTO_OPTIONS";
        ExecStop = "${libexec}/whack --shutdown";
        ExecStopPost = [
          "${pkgs.iproute}/bin/ip xfrm policy flush"
          "${pkgs.iproute}/bin/ip xfrm state flush"
          "${ipsec} --stopnflog"
        ];
        ExecReload = "${libexec}/whack --listen";
      };

    };

  };

}

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.libreswan;

  libexec = "${pkgs.libreswan}/libexec/ipsec";
  ipsec = "${pkgs.libreswan}/sbin/ipsec";

  trim = chars: str:
  let
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

  configFile = pkgs.writeText "ipsec-nixos.conf"
    ''
      config setup
      ${configText}

      ${connectionText}
    '';

  policyFiles = mapAttrs' (name: text:
    { name = "ipsec.d/policies/${name}";
      value.source = pkgs.writeText "ipsec-policy-${name}" text;
    }) cfg.policies;

in

{

  ###### interface

  options = {

    services.libreswan = {

      enable = mkEnableOption (lib.mdDoc "Libreswan IPsec service");

      configSetup = mkOption {
        type = types.lines;
        default = ''
            protostack=netkey
            virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v4:100.64.0.0/10,%v6:fd00::/8,%v6:fe80::/10
        '';
        example = ''
            secretsfile=/root/ipsec.secrets
            protostack=netkey
            virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v4:100.64.0.0/10,%v6:fd00::/8,%v6:fe80::/10
        '';
        description = lib.mdDoc "Options to go in the 'config setup' section of the Libreswan IPsec configuration";
      };

      connections = mkOption {
        type = types.attrsOf types.lines;
        default = {};
        example = literalExpression ''
          { myconnection = '''
              auto=add
              left=%defaultroute
              leftid=@user

              right=my.vpn.com

              ikev2=no
              ikelifetime=8h
            ''';
          }
        '';
        description = lib.mdDoc "A set of connections to define for the Libreswan IPsec service";
      };

      policies = mkOption {
        type = types.attrsOf types.lines;
        default = {};
        example = literalExpression ''
          { private-or-clear = '''
              # Attempt opportunistic IPsec for the entire Internet
              0.0.0.0/0
              ::/0
            ''';
          }
        '';
        description = lib.mdDoc ''
          A set of policies to apply to the IPsec connections.

          ::: {.note}
          The policy name must match the one of connection it needs to apply to.
          :::
        '';
      };

      disableRedirects = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to disable send and accept redirects for all network interfaces.
          See the Libreswan [
          FAQ](https://libreswan.org/wiki/FAQ#Why_is_it_recommended_to_disable_send_redirects_in_.2Fproc.2Fsys.2Fnet_.3F) page for why this is recommended.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    # Install package, systemd units, etc.
    environment.systemPackages = [ pkgs.libreswan pkgs.iproute2 ];
    systemd.packages = [ pkgs.libreswan ];
    systemd.tmpfiles.packages = [ pkgs.libreswan ];

    # Install configuration files
    environment.etc = {
      "ipsec.secrets".source = "${pkgs.libreswan}/etc/ipsec.secrets";
      "ipsec.conf".source = "${pkgs.libreswan}/etc/ipsec.conf";
      "ipsec.d/01-nixos.conf".source = configFile;
    } // policyFiles;

    # Create NSS database directory
    systemd.tmpfiles.rules = [ "d /var/lib/ipsec/nss 755 root root -" ];

    systemd.services.ipsec = {
      description = "Internet Key Exchange (IKE) Protocol Daemon for IPsec";
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ] ++ mapAttrsToList (n: v: v.source) policyFiles;
      path = with pkgs; [
        libreswan
        iproute2
        procps
        nssTools
        iptables
        nettools
      ];
      preStart = optionalString cfg.disableRedirects ''
        # Disable send/receive redirects
        echo 0 | tee /proc/sys/net/ipv4/conf/*/send_redirects
        echo 0 | tee /proc/sys/net/ipv{4,6}/conf/*/accept_redirects
      '';
    };

  };

}

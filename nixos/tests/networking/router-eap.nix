{ eapCerts }:
{ config, pkgs, ... }:
let
  radiusDir =
    let
      eapConfig = builtins.toFile "eap.conf" ''
        eap {
            default_eap_type = tls
            timer_expire = 60
            ignore_unknown_eap_types = no

            tls {
                # Path to CA certificate
                ca_file = ''${certdir}/ca.cert

                # Path to server certificate and private key
                certificate_file = ''${certdir}/server.cert
                private_key_file = ''${certdir}/server.key

                # Enable mutual authentication
                require_client_cert = yes

                # Cipher suite (example)
                ciphers = "DEFAULT"
            }
        }
      '';
      clientsConfig = builtins.toFile "client.conf" ''
        client localhost {
          ipaddr = 127.0.0.1
          secret = insecure
          require_message_authenticator = no
        }
      '';

      # sample users file, not used for eap-tls, only for e.g. eap-ttls
      usersConfig = builtins.toFile "users.conf" ''
        testuser	Cleartext-Password := "supersecret"
      '';

      # this constructs the freeradius config directory
      # it starts with the upstream config, then overwrites certain files
      # and uses the generated certs from eapCerts
      buildScript = pkgs.writeShellApplication {
        name = "builder";

        runtimeInputs = [ pkgs.coreutils ];

        # https://www.shellcheck.net/wiki/SC2154 -- out is referenced but not assigned.
        excludeShellChecks = [ "SC2154" ];

        text = ''
          cp --recursive  ${pkgs.freeradius}/etc/* "$out"
          chmod +w -R "$out"
          cp --force ${eapCerts}/ca.cert "$out/certs/ca.cert"
          cp --force ${eapCerts}/ca.key "$out/certs/ca.key"
          cp --force ${eapCerts}/server.cert "$out/certs/server.cert"
          cp --force ${eapCerts}/server.key "$out/certs/server.key"
          cp --force ${eapConfig} "$out/mods-enabled/eap"
          cp --force ${usersConfig} "$out/users"
          cp --force ${clientsConfig} "$out/clients.conf"
        '';
      };
    in
    derivation {
      name = "radius_dir";
      builder = "${pkgs.bash}/bin/bash";
      args = [ "${buildScript}/bin/builder" ];
      inherit (pkgs) system;
    };
  inherit (pkgs) lib;
  vlanIfs = lib.range 1 (lib.length config.virtualisation.vlans);
in
{
  virtualisation.vlans = [
    1
    2
    3
  ];
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  networking = {
    useDHCP = false;
    useNetworkd = true;
    firewall.checkReversePath = true;
    firewall.allowedUDPPorts = [ 547 ];
    interfaces = lib.mkOverride 0 (
      lib.listToAttrs (
        lib.forEach vlanIfs (
          n:
          lib.nameValuePair "eth${toString n}" {
            ipv4.addresses = [
              {
                address = "192.168.${toString n}.1";
                prefixLength = 24;
              }
            ];
            ipv6.addresses = [
              {
                address = "fd00:1234:5678:${toString n}::1";
                prefixLength = 64;
              }
            ];
          }
        )
      )
    );
  };

  services.freeradius = {
    enable = true;
    configDir = radiusDir;
    debug = true;
  };

  # upstream nixpkgs hostapd is focused on Wifi
  systemd.services.hostapd =
    let
      hostapdConfig = builtins.toFile "hostapd.conf" ''
        interface=eth1
        driver=wired
        logger_stdout=-1
        logger_stdout_level=1
        debug=2
        dump_file=/tmp/hostapd.dump
        ieee8021x=1
        eap_reauth_period=3600
        use_pae_group_addr=1
        ##### RADIUS configuration ####################################################
        own_ip_addr=127.0.0.1
        nas_identifier=ap.example.com
        auth_server_addr=127.0.0.1
        auth_server_port=1812
        auth_server_shared_secret=insecure
      '';
    in
    {
      description = "IEEE 802.11 Host Access-Point Daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.hostapd}/bin/hostapd ${hostapdConfig}";
        Restart = "always";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        RuntimeDirectory = "hostapd";
      };
    };
}

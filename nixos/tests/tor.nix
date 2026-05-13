{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Helper to get a node's auto-assigned primary IPv4 address.
  nodeIP = name: config.nodes.${name}.networking.primaryIPAddress;
  nodeIPv6 = name: config.nodes.${name}.networking.primaryIPv6Address;

  # Node name lists - used to generate keys, node configs, and DA vote targets
  daNames = lib.attrNames daKeys;
  relayNames = [
    "relay1"
    "relay2"
    "relay3"
    "relay4"
    "relay5"
  ];
  exitNames = [
    "exit1"
    "exit2"
    "exit3"
  ];

  # Relays that receive the Guard flag. DAs are excluded here (they only
  # do directory serving and voting) and exits are excluded so Guard
  # and Exit remain distinct roles.
  guardNames = relayNames;

  # These keys cannot be generated in a derivation, as their values need to be
  # used by other nodes at eval time and doing so would require IFD/equivalent.
  # We store the minimal keys for the stable identifiers we need, and let the
  # rest be generated at daemon startup.
  #
  # generation:
  # ed25519_master_id_secret_key, secret_id_key:
  #   tor --list-fingerprint --OrPort 9001 --Nickname ${name} --SocksPort 0
  # authority_identity_key:
  #   tor-gencert --create-identity-key -m 24 -a ${nodeIP}:80 \
  #     --passphrase-fd 0 >/dev/null 2>&1
  # ed25519_identity:
  #   tail -c 32 keys/ed25519_master_id_public_key | base64 -w0 | tr -d '='
  # relay_fingerprint:
  #   cut -d' ' -f2- $DATADIR/fingerprint | tr -d ' \n'
  # v3ident:
  #   grep "^fingerprint " keys/authority_certificate | awk '{print $2}' \
  #     | tr -d '\n'
  daKeys = {
    da1 = {
      ed25519_identity = "ap/z2/Nq8HdYksjWDLDvhEmKd39osTM8vVnx0izU/k0";
      relay_fingerprint = "29B044181211661E7B26ED8C07C1F0C71D904368";
      v3ident = "4E069A4CEAC2428D45FCA6C2904C10A5FE20D70D";

      authority_identity_key = ''
        -----BEGIN ENCRYPTED PRIVATE KEY-----
        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
        LlQeVAZAGK7OM9MgE7I=
        -----END ENCRYPTED PRIVATE KEY-----
      '';
      ed25519_master_id_secret_key = "PT0gZWQyNTUxOXYxLXNlY3JldDogdHlwZTAgPT0AAAA4oXThXk1yN5VjidKIbpv6+ciVFzogUE+epks8pUq3cSo2scU4TcZaMAV3c8RtUllrhBBGimkwQaGESRHKLOWO";
      secret_id_key = ''
        -----BEGIN RSA PRIVATE KEY-----
        MIICWwIBAAKBgQDVN2GyVthA/wF4pTb4pIrdOJuwSjyW74JVN1HXQI9cJRBT9S42
        8RMGPfHIEn2Mev+p6+7ROueeNxuuyjPlKSge/x9e/CAdmBaI6sqJDHMWc3PdU+Cp
        7aUIryi941UuqI6I2A0jpiVaeuCCntqCXMv+RTEBTHEZlLKsjRKUZ6bXzQIDAQAB
        AoGAEi01e/GhX/EdW/6hsBK+79sKkr3RaoCimMcth+8uCYnzWWT2eqKUn5yaRxck
        ctxtfTvq0RV3d2p1RrJgODIJBGuHyJMIZuKovYxxRJ68cWObeRxhz6vHfnrcdOMe
        3BQ6f0pNBeqsboiKMMDOPZG/JxEYxU1VySoFwdbBz4lDwqECQQD6OkjIA1YrfMjb
        oj9pwaJfi94vGLByqaQDozanz7vp5uBdpnX7Vx57adwrG/YBz1r3sqSDpeclcR6J
        9pg4WneVAkEA2iKHBb41e44l6P9GeUS3HG9o28rb2ms6xg3+YrWkdMP/UUkdNWWp
        grTceZBYB2B9Wg5QCpaScAnjlOGBJyDxWQJAeLmUEcPiWBrdQXIXDCwa7eQqbyiH
        QNrtwb+GCBKmg+QbDbPZKklO8JYTXk0gNKFZLzZmPwnU6nCYHlH2AQJMvQJAOkYn
        FB2wZAWhkxE/Xn5A/NO2i6EyArPKy8ZJQ02LVbZWqvyBVRaHpmdyzvcEzVO1qS1R
        rMJ09IFvzwI/YpimYQJAd8diRPE6BsSEOfz6sQDoNhF7duQbeI66fMJl4TpoI61d
        IoYZIaQB3F8o/MsSu3Hgklg4KWbkJTOjapr6GVEv1w==
        -----END RSA PRIVATE KEY-----
      '';
    };

    da2 = {
      ed25519_identity = "5uJ3G29TGZnAWiQRXsDmz/hni7l1hAz0SdsZftDziR4";
      relay_fingerprint = "D6A397616E8C07052B574C7AE4E996A516380299";
      v3ident = "DAD57AE8123633F92D0D1A9F522006EB3AA022F3";

      authority_identity_key = ''
        -----BEGIN ENCRYPTED PRIVATE KEY-----
        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
        xvVjIQQ+3OhFj1nb/iQ=
        -----END ENCRYPTED PRIVATE KEY-----
      '';
      ed25519_master_id_secret_key = "PT0gZWQyNTUxOXYxLXNlY3JldDogdHlwZTAgPT0AAADQ8mHqJSOLPu9kzQTqIBc1XrXC1F1fjL55ou28G5n9eM84MrS4Z+dCSpL0emwW0a/QQM59j4MvXkrY97szIB4j";
      secret_id_key = ''
        -----BEGIN RSA PRIVATE KEY-----
        MIICXQIBAAKBgQC9IVl+2l/bVAvIr2mC5mUQF180ujVjtJpQooO9M6CBznZ4Im0x
        nmlA8RyTAEGOQvQAQlY2K3t034QakFlUX1zNbnX70CuHm1vW2nXIiehTXWzw2TtD
        zLNRAULoD66ayoaLkwB3o7/7vfr2XK90ptHw7UPrABF8Q6npZ6T+6Uy9RQIDAQAB
        AoGAS8JsIxA+jZDhF4aMcU7w9L0n+esNL99MYTh4JPXlOZoGgqDntJSL/OOYWpoj
        qGTRcLkh55kLXwmZ1To1TkLU3RQIdEo+WJDrQ4eEezcLK08aSEt3nH1DYAkZCF8G
        C1Sy1XbJ5zSwW3UMzSKw+ZCZPI5pVtDAcwGq3kXeOM2IsRECQQD2+Lfw/FY/WF7e
        LP8krm+tMIgOtTRsXmtNHlYkX/r8Kbb+Sv6lbhpoP1VqStQcHMjYlJyX9Osz6g3f
        LXTKDEmTAkEAxAtS5uvDGFa+SYRmrKmywIZzHFw+1rfEJ0efYDmnnqLxbg8/Cx5F
        60gR6i5d00WCMHpcx5tXHbwJFeZev8nExwJBAIm1r+M44OKbZPKfxnjupyi7+fGx
        ipSupUgwFTpdJnb6z6XFrW4TEbh1MCx/ovw19KwHWbXFhGzDIo8CKrAK3+8CQBFa
        Uz8/dShtXTCSuKfl6X2jKQNEowdMgt9bNp9E2zJuh+JPFSx9xICcA4HwErwFtg1m
        d1nvxRlLsJ4wowhk6rcCQQCAQlelvliM7ijxJObSlRG0TFlXdCEoFwLdkwv1fIRx
        ZaK4SKIxyYHO5xXunKLhZQqr/GuXaU/J7p7P/VtkBTiH
        -----END RSA PRIVATE KEY-----
      '';
    };

    da3 = {
      ed25519_identity = "4+7rRGF6EoCWkGsmgHswDuZDzxkJ9Zg6X9aWp2+eibw";
      relay_fingerprint = "983AFA94E7CA8E0A229B397D89740329C6D71980";
      v3ident = "737C5425DA655342D410B9EB18AD99128E8E6787";

      authority_identity_key = ''
        -----BEGIN ENCRYPTED PRIVATE KEY-----
        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
        axmW2KHqp1A/0neHwRg=
        -----END ENCRYPTED PRIVATE KEY-----
      '';
      ed25519_master_id_secret_key = "PT0gZWQyNTUxOXYxLXNlY3JldDogdHlwZTAgPT0AAACImWVlo8IUSlvmr9Ycqwx7PunirHJRRKt/gbC1T4h2Vpfy5Tfsa+X9lfyR3Oj/xlYcEAifosLsW/Tb1TSYMzfv";
      secret_id_key = ''
        -----BEGIN RSA PRIVATE KEY-----
        MIICXQIBAAKBgQDClKAHnQ0aau2g1J0AIjoY4/flu2YzNm3n5GwjwVK88sCgVdRS
        mAFwZK1QMmffCbZ/Wgx25bKGY7WGz94KE80cFLsl4Ypv3J6kealM0U56D4KjX+G7
        8nvLS8UZcqryjo2qSmPRunoOc2jq/8BCTUh1s7YBq9TBAHk+kRQ5GZ63dwIDAQAB
        AoGABAju9Jl2Hxkeilo+UzVifQelKVdkfCVhzBA5idhFbfOeuPRurbPHO9xql6Ij
        80URSrzES2bh99VzezMuSIk2lJg6r8xqC6BGoyFA6LE4pDejE+h6N4rFbjZwab5J
        H2lYMShOwugCXKzCESgk3YhX5VaAcXd+DkZpCQBAwanyU0ECQQDmPuZllIbk8bkq
        lWKiREePpeMDrC6+uo1bA3ejZmuY508Zta76o0bIz3qsGCisMqJrg1vzmT/cQAyl
        O9oSUdEhAkEA2FhzpQ4z4TWaI+7Quo/cK/r6FhxOSZyDGSONVWpCTbHw2muZd9Rj
        /nluZz5Lgkyzv6sGLd4dZ2oYP4di2he9lwJBANlt8uNghJa1ktgc5F06P53u2NfC
        BQ7GWvDk8FkVQmzNmww7X3d/Mzw1erIDynz7ABipnu8G/KCAt7BeOgxsySECQQCT
        IzUjoJEwLeBzZ8yV1ZmMX9kOiJnF/qg6xK8u1GHbrZV9N4jcspp/S98GYJvCNqBZ
        TtuY/mNJHiL3sgBNC7BpAkAftgZ1PqM+2hthHYCg5rKxEtvTXfnTQQrJp1oKVg5F
        +azodtfzm8s+sW52bXwEWI/0zjfG94tQM7+jDd15ABRB
        -----END RSA PRIVATE KEY-----
      '';
    };
  };

  # Build DirAuthority lines from the pre-generated keys.
  # Format: nickname orport=PORT v3ident=V3IDENT ip:dirport RELAY_FINGERPRINT
  dirAuthorityLines = lib.mapAttrsToList (
    name: keys:
    "${name} orport=9001 ipv6=[${nodeIPv6 name}]:9001 v3ident=${keys.v3ident} ${nodeIP name}:80 ${keys.relay_fingerprint}"
  ) daKeys;

  # Tor settings shared by all node types
  commonTorSettings = {
    TestingTorNetwork = true;
    AssumeReachable = true;
    AssumeReachableIPv6 = true;
    ControlPort = 9051;
    CookieAuthentication = true;
    DirAuthority = dirAuthorityLines;
  };

  # Tor settings shared by non-DA nodes (relays and exits)
  nonDATorSettings =
    name:
    commonTorSettings
    // {
      Address = nodeIP name;
      Nickname = name;
      ContactInfo = "${name} <${name} AT localhost>";
      DirPort = 9030;
      ORPort = [
        9001
        {
          addr = "[${nodeIPv6 name}]";
          port = 9001;
        }
      ];
      SocksPort = 0;
      PublishServerDescriptor = "1";
      PathsNeededToBuildCircuits = "0.25";
    };

  # Build a directory authority node configuration
  mkDANode = name: {
    networking.firewall.allowedTCPPorts = [
      80
      9001
    ];

    systemd.services.tor = {
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
    };

    # Deploy pre-generated relay and authority keys before Tor starts.
    # This ensures the relay fingerprint matches what's in DirAuthority lines.
    system.activationScripts.tor-keys = lib.stringAfter [ "users" "groups" ] ''
      mkdir -p /var/lib/tor/keys
      cd /var/lib/tor/keys
      printf "%s" ${lib.escapeShellArg daKeys.${name}.authority_identity_key} > authority_identity_key
      printf "%s" ${
        lib.escapeShellArg daKeys.${name}.ed25519_master_id_secret_key
      } | base64 -d > ed25519_master_id_secret_key
      printf "%s" ${lib.escapeShellArg daKeys.${name}.secret_id_key} > secret_id_key
      ${lib.getExe' pkgs.tor "tor-gencert"} \
        -i authority_identity_key \
        -s authority_signing_key \
        -c authority_certificate \
        --passphrase-fd 0 < /dev/null

      touch /var/lib/tor/sr-state
      chown -R tor:tor /var/lib/tor
      chmod 700 /var/lib/tor /var/lib/tor/keys
      chmod 600 /var/lib/tor/keys/*
    '';

    services.tor = {
      enable = true;
      relay.enable = true;
      relay.role = "relay";
      settings = commonTorSettings // {
        AuthoritativeDirectory = true;
        V3AuthoritativeDirectory = true;
        Address = nodeIP name;
        Nickname = name;
        ContactInfo = "${name} <${name} AT localhost>";
        DirPort = 80;
        ORPort = [
          9001
          {
            addr = "[${nodeIPv6 name}]";
            port = 9001;
          }
        ];
        SocksPort = 0;
        # Only assign circuit-selection flags to non-DA relays (makes DAs only
        # do directory serving).
        TestingDirAuthVoteExit = lib.concatStringsSep "," exitNames;
        TestingDirAuthVoteGuard = lib.concatStringsSep "," guardNames;
        TestingDirAuthVoteHSDir = lib.concatStringsSep "," (relayNames ++ exitNames);
        TestingMinExitFlagThreshold = 0;
        V3AuthNIntervalsValid = 2;
      };
    };
  };

  # Build a relay node configuration
  mkRelayNode = name: {
    networking.firewall.allowedTCPPorts = [
      9001
      9030
    ];

    services.tor = {
      enable = true;
      relay.enable = true;
      relay.role = "relay";
      settings = nonDATorSettings name;
    };
  };

  # Build an exit node configuration.
  mkExitNode = name: {
    networking.firewall.allowedTCPPorts = [
      9001
      9030
    ];

    services.tor = {
      enable = true;
      relay.enable = true;
      relay.role = "exit";
      settings = nonDATorSettings name // {
        # relay.role = "exit" prevents the NixOS module from force-setting
        # ExitPolicy to "reject *:*", but the option's default is still "reject
        # *:*". We must explicitly set a permissive ExitPolicy for the exit to
        # be usable.
        ExitRelay = true;
        ExitPolicy = [ "accept *:*" ];
      };
    };
  };

  hiddenServiceResponse = "Hello from the hidden service";

  # Hidden service node: Caddy serves a static page, Tor exposes it as an onion service
  mkHiddenServiceNode = {
    services.caddy = {
      enable = true;
      virtualHosts."http://:8080" = {
        extraConfig = ''
          respond "${hiddenServiceResponse}"
        '';
      };
    };

    services.tor = {
      enable = true;
      relay.onionServices.web = {
        map = [
          {
            port = 80;
            target = {
              addr = "127.0.0.1";
              port = 8080;
            };
          }
        ];
      };
      settings = commonTorSettings // {
        SocksPort = 0;
      };
    };
  };

  # Client node: uses Tor SOCKS proxy to access onion services
  mkClientNode = {
    environment.systemPackages = [ pkgs.curl ];

    services.tor = {
      enable = true;
      client.enable = true;
      settings = commonTorSettings;
    };
  };

  clearnetResponse = "Hello from the clearnet";

  # Clearnet webserver to test exit node traffic
  mkWebServerNode = {
    networking.firewall.allowedTCPPorts = [ 80 ];

    services.caddy = {
      enable = true;
      virtualHosts."http://:80" = {
        extraConfig = ''
          respond "${clearnetResponse}"
        '';
      };
    };
  };

  # Arti configuration
  artiConfig = (pkgs.formats.toml { }).generate "arti.toml" {
    proxy.socks_listen = 9150;

    storage = {
      cache_dir = "/var/cache/arti";
      state_dir = "/var/lib/arti";
      port_info_file = "/var/lib/arti/public/port_info.json";
      permissions.dangerously_trust_everyone = true;
    };

    address_filter.allow_local_addrs = true;

    # Disable subnet restrictions since all nodes are on the same network
    path_rules = {
      ipv4_subnet_family_prefix = 33;
      ipv6_subnet_family_prefix = 129;
    };

    # Disable vanguards - the small test network doesn't have enough relay
    # diversity for arti to satisfy vanguard selection requirements
    vanguards.mode = "disabled";

    # Override Tor consensus parameters for the small test network.
    # Arti's guard sampling defaults are configured for the real Tor
    # network.
    override_net_params = {
      guard-max-sample-size = 4;
      guard-min-filtered-sample-size = 2;
      guard-n-primary-guards-to-use = 2;
    };

    tor_network = {
      authorities = {
        v3idents = lib.mapAttrsToList (_: keys: keys.v3ident) daKeys;
        uploads = lib.mapAttrsToList (name: _: [
          "${nodeIP name}:80"
          "[${nodeIPv6 name}]:80"
        ]) daKeys;
        downloads = lib.mapAttrsToList (name: _: [
          "${nodeIP name}:80"
          "[${nodeIPv6 name}]:80"
        ]) daKeys;
        votes = lib.mapAttrsToList (name: _: [
          "${nodeIP name}:80"
          "[${nodeIPv6 name}]:80"
        ]) daKeys;
      };
      fallback_caches = lib.mapAttrsToList (name: keys: {
        rsa_identity = keys.relay_fingerprint;
        ed_identity = keys.ed25519_identity;
        orports = [
          "${nodeIP name}:9001"
          "[${nodeIPv6 name}]:9001"
        ];
      }) daKeys;
    };
  };

  # Arti client node
  mkArtiClientNode = {
    environment.systemPackages = [ pkgs.curl ];

    systemd.services.arti = {
      description = "Arti Tor Client";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.arti} proxy -c ${artiConfig}";
        DynamicUser = true;
        StateDirectory = "arti";
        CacheDirectory = "arti";
      };
    };
  };
in
{
  name = "tor";
  meta.maintainers = with lib.maintainers; [ jpds ];

  nodes =
    lib.genAttrs daNames mkDANode
    // lib.genAttrs relayNames mkRelayNode
    // lib.genAttrs exitNames mkExitNode
    // {
      hiddenservice = mkHiddenServiceNode;
      webserver = mkWebServerNode;
      client = mkClientNode;
      articlient = mkArtiClientNode;
    };

  testScript = ''
    # Start directory authorities and wait for consensus
    for machine in da1, da2, da3:
        machine.start()
        machine.wait_for_unit("tor.service")
        machine.wait_for_open_port(9051)

    for machine in da1, da2, da3:
        machine.wait_until_succeeds(
            "journalctl -o cat -u tor.service | grep 'Scheduling voting'"
        )
        machine.wait_until_succeeds(
            "journalctl -o cat -u tor.service | grep 'Consensus computed; uploading signature(s)'"
        )

    # Start relays and exits
    for machine in relay1, relay2, relay3, relay4, relay5, exit1, exit2, exit3:
        machine.start()
        machine.wait_for_unit("tor.service")
        machine.wait_for_open_port(9051)

    # Wait for all DAs to fully bootstrap
    for machine in da1, da2, da3:
        machine.wait_until_succeeds(
            "journalctl -o cat -u tor.service | grep 'Bootstrapped 100%'"
        )

    # Wait for relays and exits to self-test and bootstrap
    for machine in relay1, relay2, relay3, relay4, relay5, exit1, exit2, exit3:
        machine.wait_until_succeeds(
            "journalctl -o cat -u tor.service | grep 'Self-testing indicates your ORPort .* is reachable'"
        )
        machine.wait_until_succeeds(
            "journalctl -o cat -u tor.service | grep 'Bootstrapped 100%'"
        )

    # Verify the Tor control port is functional
    assert "514 Authentication required." in da1.succeed(
        "echo GETINFO version | nc 127.0.0.1 9051"
    )

    # Start hidden service and clearnet webserver - then web client
    hiddenservice.start()
    hiddenservice.wait_for_unit("caddy.service")
    hiddenservice.wait_for_unit("tor.service")

    webserver.start()
    webserver.wait_for_unit("caddy.service")
    webserver.wait_for_open_port(80)

    client.start()
    client.wait_for_unit("tor.service")

    # Wait for the hidden service to generate its .onion hostname
    hiddenservice.wait_until_succeeds(
        "test -f /var/lib/tor/onion/web/hostname"
    )
    onion_addr = hiddenservice.succeed("cat /var/lib/tor/onion/web/hostname").strip()

    # Wait for the client to bootstrap
    client.wait_until_succeeds(
        "journalctl -o cat -u tor.service | grep 'Bootstrapped 100%'"
    )

    # Access the hidden service from the client via Tor SOCKS proxy
    client.wait_until_succeeds(
        f"curl --max-time 60 --socks5-hostname 127.0.0.1:9050 http://{onion_addr} | grep '${hiddenServiceResponse}'"
    )

    # Access the clearnet webserver through the Tor exit node
    webserver_ip = "${nodeIP "webserver"}"
    client.wait_until_succeeds(
        f"curl --max-time 60 --socks5-hostname 127.0.0.1:9050 http://{webserver_ip} | grep '${clearnetResponse}'"
    )

    articlient.start()
    articlient.wait_for_unit("arti.service")
    articlient.wait_for_open_port(9150)

    # Access the hidden service from the client via arti
    # Onion service access is not tested with arti. The HS client
    # doesn't work reliably on small private networks.
    # articlient.wait_until_succeeds(
    #     f"curl --max-time 60 --socks5-hostname 127.0.0.1:9150 http://{onion_addr} | grep '${hiddenServiceResponse}'"
    # )

    # Access the clearnet webserver through the Tor exit node with arti
    articlient.wait_until_succeeds(
        f"curl --max-time 60 --socks5-hostname 127.0.0.1:9150 http://{webserver_ip} | grep '${clearnetResponse}'"
    )

    da1.log(da1.succeed("systemd-analyze security tor.service | grep -v '✓'"))
  '';
}

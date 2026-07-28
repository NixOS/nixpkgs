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

  # Generate all keys (both relay identity and authority) for a
  # directory authority in a single derivation.
  #
  # tor --list-fingerprint generates the relay RSA/ed25519 identity
  # keys and writes the fingerprint file. tor-gencert then generates
  # the authority identity key, signing key, and certificate.
  mkDAKeys =
    name:
    pkgs.runCommand "tor-da-keys-${name}"
      {
        nativeBuildInputs = [ pkgs.tor ];
      }
      ''
        DATADIR=$(mktemp -d)
        mkdir -p "$DATADIR/keys"

        # Generate relay identity keys.
        tor --list-fingerprint \
            --DataDirectory "$DATADIR" \
            --ORPort 9001 \
            --Nickname "${name}" \
            --SocksPort 0 \
            >/dev/null 2>&1

        # Generate authority keys in the keys directory
        (
          cd "$DATADIR/keys"
          echo "" | tor-gencert --create-identity-key -m 24 \
              -a ${nodeIP name}:80 \
              --passphrase-fd 0 \
              >/dev/null 2>&1
        )

        # Prepare output: keys in a subdirectory, fingerprints as plain files
        mkdir -p $out/keys
        cp "$DATADIR/keys/"* $out/keys/

        # Extract relay fingerprint
        # fingerprint file format: "Nickname XXXX XXXX XXXX XXXX ..."
        cut -d' ' -f2- "$DATADIR/fingerprint" | tr -d ' \n' > $out/relay-fingerprint

        # Extract v3ident from authority certificate
        # certificate format: "fingerprint ABCDEF1234..."
        grep "^fingerprint " $out/keys/authority_certificate \
            | awk '{print $2}' | tr -d '\n' > $out/v3ident

        # Extract ed25519 identity
        tail -c 32 "$DATADIR/keys/ed25519_master_id_public_key" \
            | base64 -w0 | tr -d '=' > $out/ed25519-identity
      '';

  # Node name lists - used to generate keys, node configs, and DA vote targets
  daNames = [
    "da1"
    "da2"
    "da3"
  ];
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

  # Pre-generate keys for all directory authorities
  daKeysets = lib.genAttrs daNames mkDAKeys;

  # Script that writes /run/tor/dirauth.conf by reading the DA fingerprints
  # from the pre-generated key derivations at runtime. The ${daKeysets.<name>}
  # interpolations resolve to store-path strings at evaluation time (the
  # derivations become build dependencies of the node closure), but their
  # contents are only read when the script runs on the VM, so no
  # import-from-derivation is required.
  #
  # Written into /run/tor (tor's RuntimeDirectory, which systemd bind-mounts
  # into the service's chroot at RootDirectory=/run/tor/root) so that tor
  # can read the file despite ProtectSystem=strict.
  torDirAuthExecStartPre = pkgs.writeShellScript "tor-dirauth-conf" ''
    set -eu
    {
    ${lib.concatMapStringsSep "\n" (name: ''
      printf 'DirAuthority %s orport=9001 ipv6=[%s]:9001 v3ident=%s %s:80 %s\n' \
        ${name} \
        '${nodeIPv6 name}' \
        "$(tr -d '\n' < ${daKeysets.${name}}/v3ident)" \
        '${nodeIP name}' \
        "$(tr -d '\n' < ${daKeysets.${name}}/relay-fingerprint)"
    '') daNames}
    } > /run/tor/dirauth.conf
    chown tor:tor /run/tor/dirauth.conf
    chmod 0400 /run/tor/dirauth.conf
  '';

  # Tor settings shared by all node types. DirAuthority lines are loaded
  # from /run/tor/dirauth.conf, written by torDirAuthExecStartPre before
  # tor starts.
  commonTorSettings = {
    TestingTorNetwork = true;
    AssumeReachable = true;
    AssumeReachableIPv6 = true;
    ControlPort = 9051;
    CookieAuthentication = true;
    "%include" = "/run/tor/dirauth.conf";
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
      cp ${daKeysets.${name}}/keys/* /var/lib/tor/keys/
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

  # Arti configuration - static parts only. The tor_network section
  # embeds fingerprints from the DA key derivations, so it is generated
  # at service startup instead (see artiNetworkConfigScript) to avoid IFD.
  artiStaticConfig = (pkgs.formats.toml { }).generate "arti.toml" {
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
  };

  # Emit the tor_network section of the arti config at service startup,
  # reading fingerprints from the DA key derivations at runtime. The
  # ${daKeysets.<name>} interpolations resolve to store paths at
  # evaluation time (build dependencies), but their contents are only
  # read by the shell when the script runs - no import-from-derivation.
  artiNetworkConfigScript = pkgs.writeShellScript "arti-network-config" ''
    set -eu
    out=/run/arti/network.toml
    daIpPorts='[["${nodeIP "da1"}:80", "[${nodeIPv6 "da1"}]:80"], ["${nodeIP "da2"}:80", "[${nodeIPv6 "da2"}]:80"], ["${nodeIP "da3"}:80", "[${nodeIPv6 "da3"}]:80"]]'
    {
      echo '[tor_network.authorities]'
      printf 'v3idents = ["%s", "%s", "%s"]\n' \
        "$(tr -d '\n' < ${daKeysets.da1}/v3ident)" \
        "$(tr -d '\n' < ${daKeysets.da2}/v3ident)" \
        "$(tr -d '\n' < ${daKeysets.da3}/v3ident)"
      echo "uploads = $daIpPorts"
      echo "downloads = $daIpPorts"
      echo "votes = $daIpPorts"
    ${lib.concatMapStringsSep "\n" (name: ''
      echo
      echo '[[tor_network.fallback_caches]]'
      printf 'rsa_identity = "%s"\n' "$(tr -d '\n' < ${daKeysets.${name}}/relay-fingerprint)"
      printf 'ed_identity = "%s"\n'  "$(tr -d '\n' < ${daKeysets.${name}}/ed25519-identity)"
      echo 'orports = ["${nodeIP name}:9001", "[${nodeIPv6 name}]:9001"]'
    '') daNames}
    } > "$out"
  '';

  # Arti client node
  mkArtiClientNode = {
    environment.systemPackages = [ pkgs.curl ];

    systemd.services.arti = {
      description = "Arti Tor Client";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        RuntimeDirectory = "arti";
        ExecStartPre = artiNetworkConfigScript;
        ExecStart = "${lib.getExe pkgs.arti} proxy -c ${artiStaticConfig} -c /run/arti/network.toml";
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

  defaults =
    { config, ... }:
    lib.mkIf config.services.tor.enable {
      # Generate /run/tor/dirauth.conf before tor's own `--verify-config`
      # ExecStartPre runs. The `+` prefix makes this run as root in the
      # full system context so it can write into tor's RuntimeDirectory
      # and chown the file to tor:tor.
      systemd.services.tor.serviceConfig.ExecStartPre = lib.mkBefore [
        "+${torDirAuthExecStartPre}"
      ];
    };

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

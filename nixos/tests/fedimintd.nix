# This test checks fedimintd module evaluation, generated service settings, and startup.

{ pkgs, ... }:

let
  evalFedimintd =
    module:
    (import ../lib/eval-config.nix {
      system = builtins.currentSystem;
      modules = [
        ../modules/services/networking/fedimintd.nix
        module
      ];
    }).config;

  evalFedimintdToplevel = module: (evalFedimintd module).system.build.toplevel;

  irohConfig = evalFedimintd {
    services.fedimintd.iroh = {
      enable = true;
      api_ws.openFirewall = true;
      api_iroh.openFirewall = true;
      bitcoin.esploraUrl = "https://mempool.space/signet/api";
    };
  };

  tcpConfig = evalFedimintd {
    services.fedimintd.tcp = {
      enable = true;
      api_iroh.enable = false;
      api_iroh.openFirewall = false;
      api_ws.openFirewall = true;
      p2p.url = "fedimint://p2p.example.com:8173";
      api_ws.url = "wss://api.example.com/ws/";
      bitcoin.esploraUrl = "https://mempool.space/signet/api";
    };
  };

  metricsConfig = evalFedimintd {
    services.fedimintd = {
      first = {
        enable = true;
        metrics = {
          port = 18178;
          openFirewall = true;
        };
        bitcoin.esploraUrl = "https://mempool.space/signet/api";
      };
      second = {
        enable = true;
        metrics.port = 18179;
        bitcoin.esploraUrl = "https://mempool.space/signet/api";
      };
    };
  };

  disabledIrohNextConfig = evalFedimintd {
    services.fedimintd.disabled-iroh-next = {
      enable = true;
      api_iroh_next.enable = false;
      bitcoin.esploraUrl = "https://mempool.space/signet/api";
    };
  };
  disabledIrohNextEnvironment =
    disabledIrohNextConfig.systemd.services.fedimintd-disabled-iroh-next.environment;

  firewallChecks =
    builtins.elem 8173 irohConfig.networking.firewall.allowedTCPPorts
    && builtins.elem 8173 irohConfig.networking.firewall.allowedUDPPorts
    && builtins.elem 8173 tcpConfig.networking.firewall.allowedTCPPorts
    && builtins.elem 8173 tcpConfig.networking.firewall.allowedUDPPorts
    && builtins.elem 8174 irohConfig.networking.firewall.allowedTCPPorts
    && builtins.elem 8174 irohConfig.networking.firewall.allowedUDPPorts
    && builtins.elem 8174 tcpConfig.networking.firewall.allowedTCPPorts
    && !(builtins.elem 8174 tcpConfig.networking.firewall.allowedUDPPorts)
    && !(builtins.elem 8184 irohConfig.networking.firewall.allowedUDPPorts)
    && builtins.elem 18178 metricsConfig.networking.firewall.allowedTCPPorts
    && !(builtins.elem 18179 metricsConfig.networking.firewall.allowedTCPPorts);

  environmentChecks =
    metricsConfig.systemd.services.fedimintd-first.environment.FM_BIND_METRICS == "127.0.0.1:18178"
    && metricsConfig.systemd.services.fedimintd-second.environment.FM_BIND_METRICS == "127.0.0.1:18179"
    && disabledIrohNextEnvironment.FM_IROH_NEXT_ENABLE == "false"
    && !(disabledIrohNextEnvironment ? FM_BIND_API_NEXT);
in
assert
  !((builtins.tryEval (evalFedimintdToplevel {
    services.fedimintd.invalid-bitcoind = {
      enable = true;
      bitcoin = {
        bitcoindUrl = "http://127.0.0.1:38332";
        bitcoindUser = "bitcoin";
      };
    };
  })).success
  );
assert
  !((builtins.tryEval (evalFedimintdToplevel {
    services.fedimintd.invalid-iroh = {
      enable = true;
      api_ws.port = 18174;
      api_iroh.port = 18175;
      bitcoin.esploraUrl = "https://mempool.space/signet/api";
    };
  })).success
  );
assert
  !((builtins.tryEval (evalFedimintdToplevel {
    services.fedimintd.invalid-backend = {
      enable = true;
    };
  })).success
  );
assert
  !((builtins.tryEval (evalFedimintdToplevel {
    services.fedimintd.invalid-tcp-urls = {
      enable = true;
      api_iroh.enable = false;
      bitcoin.esploraUrl = "https://mempool.space/signet/api";
    };
  })).success
  );
assert firewallChecks;
assert environmentChecks;
assert
  !((builtins.tryEval (evalFedimintdToplevel {
    services.fedimintd = {
      first = {
        enable = true;
        bitcoin.esploraUrl = "https://mempool.space/signet/api";
      };
      second = {
        enable = true;
        bitcoin.esploraUrl = "https://mempool.space/signet/api";
      };
    };
  })).success
  );
assert
  !((builtins.tryEval (evalFedimintdToplevel {
    services.fedimintd.legacy-metrics = {
      enable = true;
      environment.FM_BIND_METRICS = "127.0.0.1:18178";
      bitcoin.esploraUrl = "https://mempool.space/signet/api";
    };
  })).success
  );
{
  name = "fedimintd";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ dpc ];
  };

  nodes.machine =
    { ... }:
    {
      services.fedimintd."mainnet" = {
        enable = true;
        passwordUiFile = "/etc/fedimintd-password-ui";
        passwordApiFile = "/etc/fedimintd-password-api";
        p2p = {
          url = "fedimint://example.com";
        };
        api_ws = {
          url = "wss://example.com";
          port = 18174;
        };
        api_iroh = {
          port = 18174;
        };
        bitcoin = {
          esploraUrl = "https://mempool.space/signet/api";
        };
        environment = { };
      };
      environment.etc.fedimintd-password-ui.text = "ui-pass";
      environment.etc.fedimintd-password-api.text = "api-pass";
    };

  nodes.bitcoind =
    { ... }:
    {
      services.fedimintd.bitcoind = {
        enable = true;
        api_ws.port = 18176;
        api_iroh = {
          port = 18176;
        };
        bitcoin = {
          bitcoindUrl = "http://127.0.0.1:38332";
          bitcoindUser = "bitcoin";
          bitcoindSecretFile = "/run/secrets/fedimintd-bitcoind-password";
        };
      };

      # The test checks the generated unit without requiring a bitcoind server.
      systemd.services.fedimintd-bitcoind.unitConfig.ConditionPathExists = "/run/does-not-exist";
    };

  nodes.no-iroh =
    { ... }:
    {
      services.fedimintd.no-iroh = {
        enable = true;
        p2p.url = "fedimint://p2p.example.com:8173";
        api_ws = {
          port = 18177;
          url = "wss://api.example.com/ws/";
        };
        api_iroh.enable = false;
        bitcoin.esploraUrl = "https://mempool.space/signet/api";
      };
    };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      machine.wait_for_unit("fedimintd-mainnet.service")
      machine.wait_for_open_port(${toString nodes.machine.services.fedimintd.mainnet.api_ws.port})
      machine.succeed("systemctl cat fedimintd-mainnet.service | grep -F 'FM_BIND_API=0.0.0.0:${toString nodes.machine.services.fedimintd.mainnet.api_ws.port}'")
      machine.succeed("systemctl cat fedimintd-mainnet.service | grep -F FM_ENABLE_IROH=true")
      machine.fail("systemctl cat fedimintd-mainnet.service | grep -F ui-pass")
      machine.fail("systemctl cat fedimintd-mainnet.service | grep -F api-pass")
      machine.succeed("systemctl cat fedimintd-mainnet.service | grep -F LoadCredential=password-ui:/etc/fedimintd-password-ui")
      machine.succeed("systemctl cat fedimintd-mainnet.service | grep -F LoadCredential=password-api:/etc/fedimintd-password-api")
      machine.succeed("xargs -0 -n1 < /proc/$(systemctl show fedimintd-mainnet.service --property=MainPID --value)/environ | grep -Fx FM_PASSWORD_UI=ui-pass")
      machine.succeed("xargs -0 -n1 < /proc/$(systemctl show fedimintd-mainnet.service --property=MainPID --value)/environ | grep -Fx FM_PASSWORD_API=api-pass")
      machine.succeed("systemctl cat fedimintd-mainnet.service | grep -F FM_IROH_NEXT_ENABLE=true")
      machine.succeed("systemctl cat fedimintd-mainnet.service | grep -F FM_BIND_API_NEXT=0.0.0.0:8184")
      bitcoind.succeed("systemctl cat fedimintd-bitcoind.service | grep -F FM_BITCOIND_URL=http://127.0.0.1:38332")
      bitcoind.succeed("systemctl cat fedimintd-bitcoind.service | grep -F FM_BITCOIND_USERNAME=bitcoin")
      bitcoind.succeed("systemctl cat fedimintd-bitcoind.service | grep -F FM_BITCOIND_URL_PASSWORD_FILE=/run/secrets/fedimintd-bitcoind-password")
      bitcoind.fail("systemctl cat fedimintd-bitcoind.service | grep -F FM_BITCOIND_PASSWORD=")
      no_iroh.wait_for_unit("fedimintd-no-iroh.service")
      no_iroh.wait_for_open_port(18177)
      no_iroh.succeed("systemctl cat fedimintd-no-iroh.service | grep -F 'FM_BIND_API=0.0.0.0:18177'")
      no_iroh.succeed("systemctl cat fedimintd-no-iroh.service | grep -F FM_P2P_URL=fedimint://p2p.example.com:8173")
      no_iroh.succeed("systemctl cat fedimintd-no-iroh.service | grep -F FM_API_URL=wss://api.example.com/ws/")
      no_iroh.succeed("systemctl cat fedimintd-no-iroh.service | grep -F FM_ENABLE_IROH=false")
      no_iroh.succeed("systemctl cat fedimintd-no-iroh.service | grep -F SocketBindAllow=udp:8184")
    '';
}

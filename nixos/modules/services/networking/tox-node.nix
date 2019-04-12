{ lib, pkgs, config, ... }:

with lib;

let
  pkg = pkgs.tox-node;
  cfg = config.services.tox-node;
  homeDir = "/var/lib/tox-node";

  bootstrapNodes = [
    { pk = "F404ABAA1C99A9D37D61AB54898F56793E1DEF8BD46B1038B9D822E8460FAB67";
      addr = "node.tox.biribiri.org:33445";
    }
    { pk = "8E7D0B859922EF569298B4D261A8CCB5FEA14FB91ED412A7603A585A25698832";
      addr = "85.172.30.117:33445";
    }
    { pk = "DA4E4ED4B697F2E9B000EEFE3A34B554ACD3F45F5C96EAEA2516DD7FF9AF7B43";
      addr = "185.25.116.107:33445";
    }
    { pk = "1C5293AEF2114717547B39DA8EA6F1E331E5E358B35F9B6B5F19317911C5F976";
      addr = "tox.verdict.gg:33445";
    }
    { pk = "AEC204B9A4501412D5F0BB67D9C81B5DB3EE6ADA64122D32A3E9B093D544327D";
      addr = "tox1.a68366.com:33445";
    }
    { pk = "2C289F9F37C20D09DA83565588BF496FAB3764853FA38141817A72E3F18ACA0B";
      addr = "163.172.136.118:33445";
    }
    { pk = "02807CF4F8BB8FB390CC3794BDF1E8449E9A8392C5D3F2200019DA9F1E812E46";
      addr = "78.46.73.141:33445";
    }
    { pk = "3F0A45A268367C1BEA652F258C85F4A66DA76BCAA667A49E770BCC4917AB6A25";
      addr = "tox.initramfs.io:33445";
    }
    { pk = "813C8F4187833EF0655B10F7752141A352248462A567529A38B6BBF73E979307";
      addr = "46.229.52.198:33445";
    }
    { pk = "7E5668E0EE09E19F320AD47902419331FFEE147BB3606769CFBE921A2A2FD34C";
      addr = "144.217.167.73:33445";
    }
    { pk = "10C00EB250C3233E343E2AEBA07115A5C28920E9C8D29492F6D00B29049EDC7E";
      addr = "tox.abilinski.com:33445";
    }
    { pk = "7467AFA626D3246343170B309BA5BDC975DF3924FC9D7A5917FBFA9F5CD5CD38";
      addr = "tmux.ru:33445";
    }
    { pk = "1B5A8AB25FFFB66620A531C4646B47F0F32B74C547B30AF8BD8266CA50A3AB59";
      addr = "37.48.122.22:33445";
    }
    { pk = "D527E5847F8330D628DAB1814F0A422F6DC9D0A300E6C357634EE2DA88C35463";
      addr = "tox.novg.net:33445";
    }
    { pk = "257744DBF57BE3E117FE05D145B5F806089428D4DCE4E3D0D50616AA16D9417E";
      addr = "95.31.18.227:33445";
    }
    { pk = "2555763C8C460495B14157D234DD56B86300A2395554BCAE4621AC345B8C1B1B";
      addr = "185.14.30.213:443";
    }
    { pk = "BEF0CFB37AF874BD17B9A8F9FE64C75521DB95A37D33C5BDB00E9CF58659C04F";
      addr = "198.199.98.108:33445";
    }
    { pk = "A04F5FE1D006871588C8EC163676458C1EC75B20B4A147433D271E1E85DAF839";
      addr = "52.53.185.100:33445";
    }
    { pk = "82EF82BA33445A1F91A7DB27189ECFC0C013E06E3DA71F588ED692BED625EC23";
      addr = "tox.kurnevsky.net:33445";
    }
    { pk = "8EF12E275BA9CD7D56625D4950F2058B06D5905D0650A1FE76AF18DB986DF760";
      addr = "tox.yikifish.com:33445";
    }
    { pk = "EDBEF0BE30CE1978F6EE9E13C1D4133409908929CC8AD7F56C4AE865B15B3177";
      addr = "52.27.228.84:33445";
    }
  ];

  configFile = pkgs.writeText "config.yml" (
    builtins.toJSON {
      log-type = cfg.logType;
      keys-file = cfg.keysFile;
      udp-address = cfg.udpAddress;
      tcp-addresses = cfg.tcpAddresses;
      tcp-connections-limit = cfg.tcpConnectionLimit;
      lan-discovery = cfg.lanDiscovery;
      threads = cfg.threads;
      motd = cfg.motd;
      bootstrap-nodes = bootstrapNodes;
    }
  );
in {
  options.services.tox-node = {
    enable = mkEnableOption "Tox Node service";

    logType = mkOption {
      type = types.enum [ "Stderr" "Stdout" "Syslog" "None" ];
      default = "Stderr";
    };
    keysFile = mkOption {
      type = types.str;
      default = "${homeDir}/keys";
    };
    udpAddress = mkOption {
      type = types.str;
      default = "0.0.0.0:33445";
    };
    tcpAddresses = mkOption {
      type = types.listOf types.str;
      default = [ "0.0.0.0:33445" ];
    };
    tcpConnectionLimit = mkOption {
      type = types.int;
      default = 8192;
    };
    lanDiscovery = mkOption {
      type = types.bool;
      default = true;
    };
    threads = mkOption {
      type = types.int;
      default = 1;
    };
    motd = mkOption {
      type = types.str;
      default = "Hi from tox-rs! I'm up {{uptime}}. TCP: incoming {{tcp_packets_in}}, outgoing {{tcp_packets_out}}, UDP: incoming {{udp_packets_in}}, outgoing {{udp_packets_out}}";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.tox-node = {
      description = "Tox Node";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkg}/bin/tox-node config ${configFile}";
        StateDirectory = "tox-node";
        DynamicUser = true;
        Restart = "always";
      };
    };
  };
}

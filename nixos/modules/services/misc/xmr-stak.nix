{ lib, config, pkgs, ... }:

with lib;

let

  cfg = config.services.xmr-stak;

  pkg = pkgs.xmr-stak.override {
    inherit (cfg) openclSupport;
  };

in

{
  options = {
    services.xmr-stak = {
      enable = mkEnableOption (lib.mdDoc "xmr-stak miner");
      openclSupport = mkEnableOption (lib.mdDoc "support for OpenCL (AMD/ATI graphics cards)");

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--noCPU" "--currency monero" ];
        description = lib.mdDoc "List of parameters to pass to xmr-stak.";
      };

      configFiles = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = literalExpression ''
          {
            "config.txt" = '''
              "verbose_level" : 4,
              "h_print_time" : 60,
              "tls_secure_algo" : true,
            ''';
            "pools.txt" = '''
              "currency" : "monero7",
              "pool_list" :
              [ { "pool_address" : "pool.supportxmr.com:443",
                  "wallet_address" : "my-wallet-address",
                  "rig_id" : "",
                  "pool_password" : "nixos",
                  "use_nicehash" : false,
                  "use_tls" : true,
                  "tls_fingerprint" : "",
                  "pool_weight" : 23
                },
              ],
            ''';
          }
        '';
        description = lib.mdDoc ''
          Content of config files like config.txt, pools.txt or cpu.txt.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.xmr-stak = {
      wantedBy = [ "multi-user.target" ];
      bindsTo = [ "network-online.target" ];
      after = [ "network-online.target" ];

      preStart = concatStrings (flip mapAttrsToList cfg.configFiles (fn: content: ''
        ln -sf '${pkgs.writeText "xmr-stak-${fn}" content}' '${fn}'
      ''));

      serviceConfig = let rootRequired = cfg.openclSupport; in {
        ExecStart = "${pkg}/bin/xmr-stak ${concatStringsSep " " cfg.extraArgs}";
        # xmr-stak generates cpu and/or gpu configuration files
        WorkingDirectory = "/tmp";
        PrivateTmp = true;
        DynamicUser = !rootRequired;
        LimitMEMLOCK = toString (1024*1024);
      };
    };
  };

  imports = [
    (mkRemovedOptionModule ["services" "xmr-stak" "configText"] ''
      This option was removed in favour of `services.xmr-stak.configFiles`
      because the new config file `pools.txt` was introduced. You are
      now able to define all other config files like cpu.txt or amd.txt.
    '')
  ];
}

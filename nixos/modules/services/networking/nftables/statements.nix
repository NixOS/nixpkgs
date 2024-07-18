{lib, ...}: let
  inherit (lib) concatStringsSep isAttrs isInt mkAfter mkMerge mkOption optional singleton;
  inherit (lib.types) attrsOf bool enum int listOf nullOr oneOf port str submodule;

  portRange = submodule {
    options = {
      from = mkOption {
        description = "Port range lower bound";
        type = port;
      };

      to = mkOption {
        description = "Port range upper bound";
        type = port;
      };
    };
  };

  ruleExt = submodule ({config, ...}: {
    options = {
      comment = mkOption {
        default = "";
        description = "Rule comment";
        type = str;
      };

      counter = mkOption {
        default = null;
        description = "Whether to count number of packets matched by this rule";
        type = nullOr (submodule {});
      };

      flow = {
        add = mkOption {
          default = [];
          description = "Adds this flow to the specified flowtable";
          type = listOf str;
        };
      };

      masquerade = mkOption {
        default = null;
        description = "Rewrite packet source address to outgoing interface's IP address";
        type = nullOr (submodule {
          options = {
            port = mkOption {
              default = null;
              description = "";
              type = nullOr (oneOf [port portRange]);
            };

            persistent = mkOption {
              default = false;
              description = "Gives a client the same source-/destination-address for each connection.";
              type = bool;
            };

            random = mkOption {
              default = false;
              description = "In kernel 5.0 and newer this is the same as fully-random. In earlier kernels the port mapping will be randomized using a seeded MD5 hash mix using source and destination address and destination port.";
              type = bool;
            };

            fullyRandom = mkOption {
              default = false;
              description = "If used then port mapping is generated based on a 32-bit pseudo-random algorithm.";
              type = bool;
            };
          };
        });
      };

      meta = {
        setMark = mkOption {
          default = 0;
          description = "Sets packet mark";
          type = int;
        };
      };

      verdict = mkOption {
        default = null;
        description = "Alters control flow in the ruleset and issues policy decisions for packets.";
        type = nullOr (enum ["accept" "drop" "queue" "continue" "return"]);
      };

      statements = mkOption {
        default = [];
        description = "nftables statements part of this rule";
        example = ["counter" "accept"];
        type = listOf str;
      };
    };

    config = {
      statements = mkMerge [
        (optional (config.counter != null) "counter")
        (optional (config.meta.setMark != 0) ''meta mark set ${toString config.meta.setMark}'')
        (optional (config.masquerade != null) (concatStringsSep " " (
          singleton "masquerade"
          ++ optional (isInt config.masquerade.port) "to :${config.masquerade.port}"
          ++ optional (isAttrs config.masquerade.port) "to :${config.masquerade.port.from}-${config.masquerade.port.to}"
          ++ concatStringsSep "," (
            optional (config.masquerade.persistent) "persistent"
            ++ optional (config.masquerade.random) "random"
            ++ optional (config.masquerade.fullyRandom) "fully-random"
          )
        )))
        (map (ft: ''flow add @${ft}'') config.flow.add)
        (optional (config.verdict != null) config.verdict)
        (optional (config.comment != "") ''comment "${config.comment}"'')
      ];

      components = mkAfter config.statements;
    };
  });

  chainExt = submodule ({options, ...}: {
    options = {
      rules = mkOption {
        type = listOf ruleExt;
      };
    };
  });

  tableExt = submodule {
    options = {
      chains = mkOption {
        type = attrsOf chainExt;
      };
    };
  };
in {
  options = {
    networking.nftables = {
      tables = mkOption {
        type = attrsOf tableExt;
      };
    };
  };
}

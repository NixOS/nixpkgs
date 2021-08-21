{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pounce;

  defaultUser = "pounce";

  settingsFormat = {
    type = types.attrsOf (types.nullOr
      (types.oneOf [ types.bool types.int types.str ]));
    generate = name: value:
      let
        mkKeyValue = k: v:
          if true == v then k
          else if false == v then "#${k}"
          else lib.generators.mkKeyValueDefault {} " = " k v;
        mkKeyValueList = values:
          lib.generators.toKeyValue { inherit mkKeyValue; } values;
      in pkgs.writeText name (mkKeyValueList value);
  };

in {
  options.services.pounce = {
    enable = mkEnableOption "Pounce IRC bouncer with the Calico dispatcher";

    user = mkOption {
      type = types.str;
      default = defaultUser;
      description = ''
        User account under which Pounce runs. If not specified, a default user
        will be created.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/pounce";
      description = ''
        Directory where each Pounce instance's UNIX-domain socket is stored for
        Calico to route to. Certificates can also be stored here.
      '';
    };

    certDir = mkOption {
      type = types.str;
      default = "/var/lib/pounce/certs";
      example = "/etc/letsencrypt/live";
      description = ''
        Directory where each Pounce instance's TLS sertificates and private
        keys are stored. Each instance should have a folder in the certbot
        format: a <literal>fullchain.pem</literal> and
        <literal>privkey.pem</literal> in a folder with the full domain name of
        the instance (ex: <literal>libera.example.org/</literal>). Self-signed
        certificates will be generated in this folder if
        <option>services.pounce.generateCerts</option> is true.
      '';
    };

    host = mkOption {
      type = types.str;
      default = "localhost";
      example = "example.org";
      description = ''
        Base domain name for Calico to listen at. Each instance will be at a
        subdomain of this.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 6697;
      description = ''
        Port for Calico to listen on.
      '';
    };

    generateCerts = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Generate a self-signed TLS certificate in the certificate directory.
        If you would like to use <command>certbot</command> instead, generate
        certificates for each instance like this:
        <literal>certbot certonly -d libera.example.org</literal>.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open port in the firewall for Calico.
      '';
    };

    timeout = mkOption {
      type = types.ints.positive;
      default = 1000;
      description = ''
        Timeout parameter (in milliseconds) for Calico to close a connection
        if no <literal>ClientHello</literal> message is sent.
      '';
    };

    networks = mkOption {
      type = types.attrsOf settingsFormat.type;
      default = {};
      example = {
        libera = {
          host = "irc.libera.chat";
          port = 6697;
          sasl-plain = "testname:password";
          join = "#nixos,#nixos-dev";
        };
      };
      description = ''
        Attribute set of Pounce configurations. For information on the Pounce
        configuration format, see the
        <link xlink:href="https://git.causal.agency/pounce/about/pounce.1">pounce(1)</link>
        manual page.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services = mkMerge [
      {
        calico = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          description = "Calico dispatcher for Pounce IRC bouncer.";

          serviceConfig = {
            User = cfg.user;
            Group = cfg.user;
            RuntimeDirectory = "pounce";
            ExecStart = ''
              ${pkgs.pounce}/bin/calico \
                -H ${cfg.host} -P ${toString cfg.port} \
                -t ${toString cfg.timeout} ${cfg.dataDir}
            '';
            Restart = "always";
            ExecStartPre = ''
              +${pkgs.bash}/bin/bash -c '\
                mkdir -p ${cfg.dataDir} && \
                chown ${cfg.user}:${cfg.user} ${cfg.dataDir} && \
                chmod 700 ${cfg.dataDir}'
            '';
          };
        };
      }

      (mapAttrs' (name: value: nameValuePair "pounce-${name}" {
        wantedBy = [ "multi-user.target" ];
        bindsTo = [ "calico.service" ];
        after = [ "calico.service" ];

        description = "Pounce IRC bouncer for the ${name} network.";

        serviceConfig = {
          User = cfg.user;
          Group = cfg.user;
          RuntimeDirectory = "pounce";
          ExecStart = ''
            ${pkgs.pounce}/bin/pounce \
              -C ${cfg.certDir}/${name}.${cfg.host}/fullchain.pem \
              -K ${cfg.certDir}/${name}.${cfg.host}/privkey.pem \
              -U ${cfg.dataDir} -H ${name}.${cfg.host} \
              ${settingsFormat.generate "${name}.cfg" value}
          '';
          Restart = "always";
        };
        preStart = ''
          mkdir -p ${cfg.certDir}/${name}.${cfg.host}

          if ${boolToString cfg.generateCerts}; then
            if [ ! -f ${cfg.certDir}/${name}.${cfg.host}/fullchain.pem ] || \
               [ ! -f ${cfg.certDir}/${name}.${cfg.host}/privkey.pem ]; then
              ${pkgs.libressl}/bin/openssl req -x509 -newkey rsa:4096 \
                -out ${cfg.certDir}/${name}.${cfg.host}/fullchain.pem \
                -keyout ${cfg.certDir}/${name}.${cfg.host}/privkey.pem \
                -nodes -sha256 -days 36500 -subj "/CN=${name}.${cfg.host}"
            fi
          fi
        '';
      }) cfg.networks)
    ];

    users = optionalAttrs (cfg.user == defaultUser) {
      users.${defaultUser} = {
        group = defaultUser;
        isSystemUser = true;
      };

      groups.${defaultUser} = { };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
    environment.systemPackages = [ pkgs.pounce ];
  };

  meta = {
    doc = ./pounce.xml;
    maintainers = [ lib.maintainers.jbellerb ];
  };
}

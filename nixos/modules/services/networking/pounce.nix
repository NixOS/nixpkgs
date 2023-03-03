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

  hardeningFlags = {
    CapabilityBoundingSet = [ "" ];
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateMounts = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
    RestrictNamespaces = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
  };

in {
  options.services.pounce = {
    enable = mkEnableOption
      (lib.mdDoc "the Pounce IRC bouncer and Calico dispatcher");

    user = mkOption {
      type = types.str;
      default = defaultUser;
      description = lib.mdDoc ''
        User account under which Pounce runs. If not specified, a default user
        will be created.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/run/pounce";
      description = lib.mdDoc ''
        Directory where each Pounce instance's UNIX-domain socket is stored for
        Calico to route to.
      '';
    };

    certDir = mkOption {
      type = types.str;
      default = "/var/lib/pounce/certs";
      example = "/etc/letsencrypt/live";
      description = lib.mdDoc ''
        Directory where each Pounce instance's TLS certificates and private
        keys are stored. Each instance should have a folder in the certbot
        format: a {file}`fullchain.pem` and {file}`privkey.pem` in a folder
        with the full domain name of the instance (ex:
        {file}`libera.example.org/`). Self-signed certificates will be
        generated in this folder if
        {option}`services.pounce.generateCerts` is true.
      '';
    };

    host = mkOption {
      type = types.str;
      default = "localhost";
      example = "example.org";
      description = lib.mdDoc ''
        Base domain name for Calico to listen at. Each instance will be at a
        subdomain of this.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 6697;
      description = lib.mdDoc "Port for Calico to listen on.";
    };

    generateCerts = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Generate a self-signed TLS certificate in the certificate directory.
        If you would like to use {command}`certbot` instead, generate
        certificates for each instance like this:
        {command}`certbot certonly -d libera.example.org`.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Open port in the firewall for Calico.";
    };

    timeout = mkOption {
      type = types.ints.positive;
      default = 1000;
      description = lib.mdDoc ''
        Timeout parameter (in milliseconds) for Calico to close a connection
        if no `ClientHello` message is sent.
      '';
    };

    networks = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          config = mkOption {
            type = settingsFormat.type;
            default = {};
            example = {
              libera = {
                host = "irc.libera.chat";
                port = 6697;
                sasl-plain = "testname:password";
                join = "#nixos,#nixos-dev";
              };
            };
            description = lib.mdDoc ''
              Pounce configuration to user for the network. For information on
              what options Pounce accepts, see the
              [pounce(1)](https://git.causal.agency/pounce/about/pounce.1)
              manual page.
            '';
          };

          notify = mkOption {
            type = types.submodule {
              options = {
                insecure = mkOption {
                  type = types.bool;
                  default = false;
                  description = lib.mdDoc ''
                    Disable certificate validation for connecting to the Pounce
                    instance. Overrides
                    {option}`services.pounce.networks.<name>.notify.trust-cert`.
                  '';
                };
                trust-cert = mkOption {
                  type = types.nullOr types.str;
                  default = "";
                  example = "/etc/letsencrypt/live/libera.irc.example.org/fullchain.pem";
                  description = lib.mdDoc ''
                    Pounce certificate for the pounce-notify client to trust.
                    This is required if Pounce is using a self-signed
                    certificate. If left blank, pounce-notify will use the
                    appropriate certificate in
                    {option}`services.pounce.certDir`. Set to `null` to disable
                    certificate pinning.
                  '';
                };
                client-cert = mkOption {
                  type = types.str;
                  default = "";
                  description = lib.mdDoc ''
                    Client certificate to use if Pounce is configured to require
                    certificate authentication. If the relevant private key is
                    stored in a separate file, load it with
                    {option}`services.pounce.networks.<name>.notify.client-priv`.
                  '';
                };
                client-priv = mkOption {
                  type = types.str;
                  default = "";
                  description = lib.mdDoc ''
                    Private key to use if Pounce is configured to require
                    certificate authentication. If the certificate provided in
                    {option}`services.pounce.networks.<name>.notify.client-cert`
                    has an embedded private key, this option can be left
                    empty.
                  '';
                };
                user = mkOption {
                  type = types.str;
                  default = "pounce-notify";
                  description = lib.mdDoc ''
                    Username to present to Pounce when connecting.
                  '';
                };
                script = mkOption {
                  type = types.lines;
                  default = "";
                  example = ''
                    # Pushover example

                    if [ -z "$NOTIFY_CHANNEL" ]; then
                      TITLE="Private Message"
                      CONTEXT="$NOTIFY_NICK"
                    else
                      TITLE="Mention"
                      CONTEXT="$NOTIFY_CHANNEL"
                    fi

                    $${pkgs.curl}/bin/curl \
                      -X POST \
                      --form-string token="API_TOKEN" \
                      --form-string user="USER_KEY" \
                      --form-string title="(libera/$CONTEXT) $TITLE" \
                      --form-string timestamp="$NOTIFY_TIME" \
                      --form-string message="$NOTIFY_NICK: $NOTIFY_MESSAGE" \
                      https://api.pushover.net/1/messages.json
                  '';
                  description = lib.mdDoc ''
                    Commands to run when a private message or a mention
                    occurs. See
                    [pounce-notify(1)](https://git.causal.agency/pounce/about/extra/notify/pounce-notify.1)
                    for a list of environment variables containing information
                    about the notification event.
                  '';
                };
                command = mkOption {
                  type = types.str;
                  default = "";
                  example = "/var/lib/pounce/notify.sh";
                  description = lib.mdDoc ''
                    Command to run when a private message or a mention occurs.
                    Overrides
                    {option}`services.pounce.notify.networks.<name>.notify.script`.
                    See
                    [pounce-notify(1)](https://git.causal.agency/pounce/about/extra/notify/pounce-notify.1)
                    for a list of environment variables containing information
                    about the notification event.
                  '';
                };
              };
            };
            default = {};
            example = { script = "/var/lib/pounce/notify.sh"; };
            description = lib.mdDoc ''
              Configuration for pounce-notify. A notification client will be
              spawned if either
              {option}`services.pounce.networks.<name>.notify.script` or
              {option}`services.pounce.networks.<name>.notify.command` is set.
            '';
          };
        };
      });
      default = {};
      description = lib.mdDoc "Attribute set of IRC networks to connect to.";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d ${cfg.dataDir} 0700 ${cfg.user} ${cfg.user} -" ];
    systemd.services = mkMerge (
      [
        {
          calico = {
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];

            description = "Calico dispatcher for Pounce IRC bouncer.";

            serviceConfig = {
              User = cfg.user;
              Group = cfg.user;
              ExecStart = ''
                ${pkgs.pounce}/bin/calico \
                  -H ${cfg.host} -P ${toString cfg.port} \
                  -t ${toString cfg.timeout} ${cfg.dataDir}
              '';
              Restart = "on-failure";
            } // hardeningFlags;
          };
        }
      ] ++ (mapAttrsToList (name: value: mkMerge [
        {
          "pounce-${name}" = {
            wantedBy = [ "calico.service" ];
            after = [ "network.target" ];
            before = [ "calico.service" ];

            description = "Pounce IRC bouncer for the ${name} network.";

            serviceConfig = {
              User = cfg.user;
              Group = cfg.user;
              ExecStart = ''
                ${pkgs.pounce}/bin/pounce \
                  -C ${cfg.certDir}/${name}.${cfg.host}/fullchain.pem \
                  -K ${cfg.certDir}/${name}.${cfg.host}/privkey.pem \
                  -U ${cfg.dataDir} -H ${name}.${cfg.host} \
                  ${settingsFormat.generate "${name}.cfg" value.config}
              '';
              Restart = "on-failure";
            } // hardeningFlags;
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
          };
        }

        (mkIf (value.notify.command != "" || value.notify.script != "") {
          "pounce-${name}-notify" = {
            wantedBy = [ "multi-user.target" ];
            requires = [ "calico.service" "pounce-${name}.service" ];
            after = [ "calico.service" "pounce-${name}.service" ];

            description = "Pounce notification client for the ${name} network.";

            serviceConfig = {
              User = cfg.user;
              Group = cfg.user;
              Environment = "SHELL=${pkgs.bash}/bin/bash";
              ExecStart = ''
                ${pkgs.pounce-extra}/bin/pounce-notify \
                   ${if value.notify.insecure then "-!" else
                     if value.notify.trust-cert == "" then
                       "-t ${cfg.certDir}/${name}.${cfg.host}/fullchain.pem"
                     else if value.notify.trust-cert != null then
                       "-t ${value.notify.trust-cert}" else ""} \
                   ${if value.notify.client-cert != "" then "-c ${value.notify.client-cert}" else ""} \
                   ${if value.notify.client-priv != "" then "-k ${value.notify.client-priv}" else ""} \
                   -p ${toString cfg.port} \
                   -u ${value.notify.user} \
                   ${if cfg.networks.${name}.config ? local-pass then
                     "-w ${cfg.networks.${name}.config.local-pass}" else ""} \
                   ${name}.${cfg.host} \
                   ${if value.notify.command != "" then "\"${value.notify.command}\"" else
                     pkgs.writeShellScript "pounce-${name}-notify-script" value.notify.script}
              '';
              Restart = "on-failure";

              # pounce will refuse all connections before it's connected to the
              # IRC network, but there's no easy way for systemd to know when
              # that's happened. The best I've come up with is starting
              # pounce-notify anyways and retrying with a fairly long delay.
              # This value works for me, hopefully it works for you too.
              RestartSec = "15s";
            } // hardeningFlags;
          };
        })
      ]) cfg.networks)
    );

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
    doc = ./pounce.md;
    maintainers = [ lib.maintainers.jbellerb ];
  };
}

{ config, lib, pkgs, ... }:
with lib;

let
  cfg     = config.services.dnscrypt-wrapper;
  dataDir = "/var/lib/dnscrypt-wrapper";

  daemonArgs = with cfg; [
    "--listen-address=${address}:${toString port}"
    "--resolver-address=${upstream.address}:${toString upstream.port}"
    "--provider-name=${providerName}"
    "--provider-publickey-file=public.key"
    "--provider-secretkey-file=secret.key"
    "--provider-cert-file=${providerName}.crt"
    "--crypt-secretkey-file=${providerName}.key"
  ];

  genKeys = ''
    # generates time-limited keypairs
    keyGen() {
      dnscrypt-wrapper --gen-crypt-keypair \
        --crypt-secretkey-file=${cfg.providerName}.key

      dnscrypt-wrapper --gen-cert-file \
        --crypt-secretkey-file=${cfg.providerName}.key \
        --provider-cert-file=${cfg.providerName}.crt \
        --provider-publickey-file=public.key \
        --provider-secretkey-file=secret.key \
        --cert-file-expire-days=${toString cfg.keys.expiration}
    }

    cd ${dataDir}

    # generate provider keypair (first run only)
    if [ ! -f public.key ] || [ ! -f secret.key ]; then
      dnscrypt-wrapper --gen-provider-keypair
    fi

    # generate new keys for rotation
    if [ ! -f ${cfg.providerName}.key ] || [ ! -f ${cfg.providerName}.crt ]; then
      keyGen
    fi
  '';

  rotateKeys = ''
    # check if keys are not expired
    keyValid() {
      fingerprint=$(dnscrypt-wrapper --show-provider-publickey | awk '{print $(NF)}')
      dnscrypt-proxy --test=${toString (cfg.keys.checkInterval + 1)} \
        --resolver-address=127.0.0.1:${toString cfg.port} \
        --provider-name=${cfg.providerName} \
        --provider-key=$fingerprint
    }

    cd ${dataDir}

    # archive old keys and restart the service
    if ! keyValid; then
      echo "certificate soon to become invalid; backing up old cert"
      mkdir -p oldkeys
      mv -v ${cfg.providerName}.key oldkeys/${cfg.providerName}-$(date +%F-%T).key
      mv -v ${cfg.providerName}.crt oldkeys/${cfg.providerName}-$(date +%F-%T).crt
      systemctl restart dnscrypt-wrapper
    fi
  '';

in {


  ###### interface

  options.services.dnscrypt-wrapper = {
    enable = mkEnableOption "DNSCrypt wrapper";

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        The DNSCrypt wrapper will bind to this IP address.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 5353;
      description = ''
        The DNSCrypt wrapper will listen for DNS queries on this port.
      '';
    };

    providerName = mkOption {
      type = types.str;
      default = "2.dnscrypt-cert.${config.networking.hostName}";
      example = "2.dnscrypt-cert.myresolver";
      description = ''
        The name that will be given to this DNSCrypt resolver.
        Note: the resolver name must start with <literal>2.dnscrypt-cert.</literal>.
      '';
    };

    upstream.address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        The IP address of the upstream DNS server DNSCrypt will "wrap".
      '';
    };

    upstream.port = mkOption {
      type = types.int;
      default = 53;
      description = ''
        The port of the upstream DNS server DNSCrypt will "wrap".
      '';
    };

    keys.expiration = mkOption {
      type = types.int;
      default = 30;
      description = ''
        The duration (in days) of the time-limited secret key.
        This will be automatically rotated before expiration.
      '';
    };

    keys.checkInterval = mkOption {
      type = types.int;
      default = 1440;
      description = ''
        The time interval (in minutes) between key expiration checks.
      '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.users.dnscrypt-wrapper = {
      description = "dnscrypt-wrapper daemon user";
      home = "${dataDir}";
      createHome = true;
    };
    users.groups.dnscrypt-wrapper = { };

    security.polkit.extraConfig = ''
      // Allow dnscrypt-wrapper user to restart dnscrypt-wrapper.service
      polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              action.lookup("unit") == "dnscrypt-wrapper.service" &&
              subject.user == "dnscrypt-wrapper") {
              return polkit.Result.YES;
          }
        });
    '';

    systemd.services.dnscrypt-wrapper = {
      description = "dnscrypt-wrapper daemon";
      after    = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path     = [ pkgs.dnscrypt-wrapper ];

      serviceConfig = {
        User = "dnscrypt-wrapper";
        WorkingDirectory = dataDir;
        Restart   = "on-failure";
        ExecStart = "${pkgs.dnscrypt-wrapper}/bin/dnscrypt-wrapper ${toString daemonArgs}";
      };

      preStart = genKeys;
    };


    systemd.services.dnscrypt-wrapper-rotate = {
      after    = [ "network.target" ];
      requires = [ "dnscrypt-wrapper.service" ];
      description = "Rotates DNSCrypt wrapper keys if soon to expire";

      path   = with pkgs; [ dnscrypt-wrapper dnscrypt-proxy gawk ];
      script = rotateKeys;
      serviceConfig.User = "dnscrypt-wrapper";
    };


    systemd.timers.dnscrypt-wrapper-rotate = {
      description = "Periodically check DNSCrypt wrapper keys for expiration";
      wantedBy = [ "multi-user.target" ];

      timerConfig = {
        Unit = "dnscrypt-wrapper-rotate.service";
        OnBootSec = "1min";
        OnUnitActiveSec = cfg.keys.checkInterval * 60;
      };
    };

  };
}

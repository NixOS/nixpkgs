{ config, lib, pkgs, ... }:
with lib;

let
  cfg     = config.services.dnscrypt-wrapper;
  dataDir = "/var/lib/dnscrypt-wrapper";

  mkPath = path: default:
    if path != null
      then toString path
      else default;

  publicKey = mkPath cfg.providerKey.public "${dataDir}/public.key";
  secretKey = mkPath cfg.providerKey.secret "${dataDir}/secret.key";

  daemonArgs = with cfg; [
    "--listen-address=${address}:${toString port}"
    "--resolver-address=${upstream.address}:${toString upstream.port}"
    "--provider-name=${providerName}"
    "--provider-publickey-file=${publicKey}"
    "--provider-secretkey-file=${secretKey}"
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
        --provider-publickey-file=${publicKey} \
        --provider-secretkey-file=${secretKey} \
        --cert-file-expire-days=${toString cfg.keys.expiration}
    }

    cd ${dataDir}

    # generate provider keypair (first run only)
    ${optionalString (cfg.providerKey.public == null || cfg.providerKey.secret == null) ''
      if [ ! -f ${publicKey} ] || [ ! -f ${secretKey} ]; then
        dnscrypt-wrapper --gen-provider-keypair
      fi
    ''}

    # generate new keys for rotation
    if [ ! -f ${cfg.providerName}.key ] || [ ! -f ${cfg.providerName}.crt ]; then
      keyGen
    fi
  '';

  rotateKeys = ''
    # check if keys are not expired
    keyValid() {
      fingerprint=$(dnscrypt-wrapper \
        --show-provider-publickey \
        --provider-publickey-file=${publicKey} \
        | awk '{print $(NF)}')
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


  # This is the fork of the original dnscrypt-proxy maintained by Dyne.org.
  # dnscrypt-proxy2 doesn't provide the `--test` feature that is needed to
  # correctly implement key rotation of dnscrypt-wrapper ephemeral keys.
  dnscrypt-proxy1 = pkgs.callPackage
    ({ stdenv, fetchFromGitHub, autoreconfHook
    , pkg-config, libsodium, ldns, openssl, systemd }:

    stdenv.mkDerivation rec {
      pname = "dnscrypt-proxy";
      version = "2019-08-20";

      src = fetchFromGitHub {
        owner = "dyne";
        repo = "dnscrypt-proxy";
        rev = "07ac3825b5069adc28e2547c16b1d983a8ed8d80";
        sha256 = "0c4mq741q4rpmdn09agwmxap32kf0vgfz7pkhcdc5h54chc3g3xy";
      };

      configureFlags = optional stdenv.isLinux "--with-systemd";

      nativeBuildInputs = [ autoreconfHook pkg-config ];

      # <ldns/ldns.h> depends on <openssl/ssl.h>
      buildInputs = [ libsodium openssl.dev ldns ] ++ optional stdenv.isLinux systemd;

      postInstall = ''
        # Previous versions required libtool files to load plugins; they are
        # now strictly optional.
        rm $out/lib/dnscrypt-proxy/*.la
      '';

      meta = {
        description = "A tool for securing communications between a client and a DNS resolver";
        homepage = "https://github.com/dyne/dnscrypt-proxy";
        license = licenses.isc;
        maintainers = with maintainers; [ rnhmjoj ];
        platforms = platforms.linux;
      };
    }) { };

in {


  ###### interface

  options.services.dnscrypt-wrapper = {
    enable = mkEnableOption (lib.mdDoc "DNSCrypt wrapper");

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        The DNSCrypt wrapper will bind to this IP address.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 5353;
      description = lib.mdDoc ''
        The DNSCrypt wrapper will listen for DNS queries on this port.
      '';
    };

    providerName = mkOption {
      type = types.str;
      default = "2.dnscrypt-cert.${config.networking.hostName}";
      defaultText = literalExpression ''"2.dnscrypt-cert.''${config.networking.hostName}"'';
      example = "2.dnscrypt-cert.myresolver";
      description = lib.mdDoc ''
        The name that will be given to this DNSCrypt resolver.
        Note: the resolver name must start with `2.dnscrypt-cert.`.
      '';
    };

    providerKey.public = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/etc/secrets/public.key";
      description = lib.mdDoc ''
        The filepath to the provider public key. If not given a new
        provider key pair will be generated on the first run.
      '';
    };

    providerKey.secret = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/etc/secrets/secret.key";
      description = lib.mdDoc ''
        The filepath to the provider secret key. If not given a new
        provider key pair will be generated on the first run.
      '';
    };

    upstream.address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        The IP address of the upstream DNS server DNSCrypt will "wrap".
      '';
    };

    upstream.port = mkOption {
      type = types.int;
      default = 53;
      description = lib.mdDoc ''
        The port of the upstream DNS server DNSCrypt will "wrap".
      '';
    };

    keys.expiration = mkOption {
      type = types.int;
      default = 30;
      description = lib.mdDoc ''
        The duration (in days) of the time-limited secret key.
        This will be automatically rotated before expiration.
      '';
    };

    keys.checkInterval = mkOption {
      type = types.int;
      default = 1440;
      description = lib.mdDoc ''
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
      isSystemUser = true;
      group = "dnscrypt-wrapper";
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

      path   = with pkgs; [ dnscrypt-wrapper dnscrypt-proxy1 gawk ];
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

    assertions = with cfg; [
      { assertion = (providerKey.public == null && providerKey.secret == null) ||
                    (providerKey.secret != null && providerKey.public != null);
        message = "The secret and public provider key must be set together.";
      }
    ];

  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}

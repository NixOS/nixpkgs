{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fastapi-dls;
  stateDir = "/var/lib/fastapi-dls";
  dls_privkey = "${stateDir}/instance.private.pem";
  dls_pubkey = "${stateDir}/instance.public.pem";
  https_privkey = "${stateDir}/webserver.key";
  https_cert = "${stateDir}/webserver.crt";
in
{
  options = {
    services.fastapi-dls = {
      enable = lib.mkEnableOption "fastapi-dls";

      package = lib.mkPackageOption pkgs "fastapi-dls" { };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The IP address on which `fastapi-dls` listens.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8081;
        description = "The port on which `fastapi-dls` listens.";
      };

      dlsAddress = lib.mkOption {
        type = lib.types.str;
        default = cfg.listenAddress;
        defaultText = lib.literalExpression "config.services.fastapi-dls.listenAddress";
        description = ''
          The HTTPS domain name that DLS clients should connect to.
          Useful when you put `fastapi-dls` behind a reverse proxy.
        '';
      };

      dlsPort = lib.mkOption {
        type = lib.types.port;
        default = cfg.port;
        defaultText = lib.literalExpression "config.services.fastapi-dls.port";
        description = "The port that DLS clients should connect to.";
      };

      openFirewall = lib.mkEnableOption "opening the firewall for `fastapi-dls`";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.fastapi-dls = {
      description = "fastapi-dls daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      preStart = ''
        if [ ! -f "${dls_privkey}" ]; then
          ${lib.getExe pkgs.openssl} genrsa -out "${dls_privkey}" 2048
        fi
        if [ ! -f "${dls_pubkey}" ]; then
          ${lib.getExe pkgs.openssl} rsa -in "${dls_privkey}" -outform PEM -pubout -out "${dls_pubkey}"
        fi
        if [ ! -f "${https_privkey}" ] || [ ! -f "${https_cert}" ]; then
          ${lib.getExe pkgs.openssl} req -x509 -nodes \
            -days 3650 -newkey rsa:2048 -subj "/CN=fastapi-dls" \
            -keyout "${https_privkey}" -out "${https_cert}"
        fi
      '';
      environment = {
        DLS_URL = cfg.dlsAddress;
        DLS_PORT = builtins.toString cfg.dlsPort;
        LEASE_EXPIRE_DAYS = builtins.toString 90;
        LEASE_RENEWAL_PERIOD = builtins.toString 0.2;
        DATABASE = "sqlite:///${stateDir}/db.sqlite";
        INSTANCE_KEY_RSA = dls_privkey;
        INSTANCE_KEY_PUB = dls_pubkey;
      };
      script = ''
        ${lib.getExe cfg.package} \
          --host ${cfg.listenAddress} \
          --port ${builtins.toString cfg.port} \
          --ssl-keyfile ${https_privkey} \
          --ssl-certfile ${https_cert}
      '';
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = builtins.baseNameOf stateDir;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ MakiseKurisu ];
}

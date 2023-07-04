{config, lib, pkgs, ...}:
let
  cfg = config.services.gnunet;
  format = pkgs.formats.ini { };

  configFile = format.generate "gnunet-config.conf" cfg.settings;
in
{
  options = {
    services.gnunet = {
      enable = lib.mkEnableOption "GNUnet daemon";
      package = lib.mkPackageOption pkgs "gnunet" { };
      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;
          options = {
            transport-udp.PORT = lib.mkOption {
              default = 2086;
              type = lib.types.port;
              description = "The UDP port for use by GNUnet.";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.gnunet = {
      group = "gnunet";
      description = "GNUnet User";
      uid = config.ids.uids.gnunet;
    };
    users.groups.gnunet.gid = config.ids.gids.gnunet;
    users.groups.gnunetdns.gid = config.ids.gids.gnunetdns;

    # TODO: Avoid putting these in $PATH
    security.wrappers = let
      mkGnunetSuid = source: {
        setuid = true;
        owner = "root";
        group = "gnunet";
        permissions = "o+rx,o-w,g+rx,g-w,o-rwx";
        inherit source;
      };
      helpers = b: "${cfg.package}/lib/gnunet/libexec/${b}";
    in {
      gnunet-helper-vpn = mkGnunetSuid (helpers "gnunet-helper-vpn");
      # These don't exist
      #gnunet-helper-transport-wlan = mkGnunetSuid (helpers "gnunet-helper-transport-wlan");
      #gnunet-helper-transport-bluetooth = mkGnunetSuid (helpers "gnunet-helper-transport-bluetooth");
      gnunet-helper-exit = mkGnunetSuid (helpers "gnunet-helper-exit");
      gnunet-helper-nat-server = mkGnunetSuid (helpers "gnunet-helper-nat-server");
      gnunet-helper-nat-client = mkGnunetSuid (helpers "gnunet-helper-nat-client");
      # > The binary should then be owned by root and be in group "gnunetdns"
      # > and be installed SUID and only be group-executable (2750).
      # But logically it should be 4750
      gnunet-helper-dns = {
        setuid = true;
        owner = "root";
        group = "gnunetdns";
        permissions = "o+rx,o-w,g+rx,g-w,o-rwx";
        source = (helpers "gnunet-helper-dns");
      };
      gnunet-service-dns = {
        setgid = true;
        owner = "root";
        group = "gnunetdns";
        permissions = "o+rx,o-w,g-rwx,o-rwx";
        source = (helpers "gnunet-service-dns");
      };
    };

    services.gnunet.settings = {
      arm = {
        START_SYSTEM_SERVICES = lib.mkDefault "YES";
        START_USER_SERVICES = lib.mkDefault "NO";
      };
      dns = {
        BINARY = lib.mkDefault "/run/wrappers/bin/gnunet-service-dns";
      };
      PATHS = {
        SUID_BINARY_PATH = lib.mkDefault "/run/wrappers/bin";
        GNUNET_HOME = lib.mkDefault "/var/lib/gnunet";
        GNUNET_RUNTIME_DIR = lib.mkDefault "/run/gnunet";
        GNUNET_USER_RUNTIME_DIR = lib.mkDefault "/run/gnunet";
        GNUNET_DATA_HOME = lib.mkDefault "/var/lib/gnunet/data";
      };
    };

    systemd.services.gnunet = {
      description = "GNUnet system deamon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package pkgs.miniupnpc ];
      serviceConfig = {
        ExecStart = "${cfg.package}/lib/gnunet/libexec/gnunet-service-arm -c ${configFile}";
        User = "gnunet";
        Group = "gnunet";
        StateDirectory = "gnunet";
        StateDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/gnunet";
        RuntimeDirectory = "gnunet";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}

{ config, lib, pkgs, ... }:
let
  cfg = config.services.tigerbeetle;
in
{
  meta = {
    maintainers = with lib.maintainers; [ danielsidhion ];
    doc = ./tigerbeetle.md;
    buildDocsInSandbox = true;
  };

  options = {
    services.tigerbeetle = with lib; {
      enable = mkEnableOption "TigerBeetle server";

      package = mkPackageOption pkgs "tigerbeetle" { };

      clusterId = mkOption {
        type = types.either types.ints.unsigned (types.strMatching "[0-9]+");
        default = 0;
        description = ''
          The 128-bit cluster ID used to create the replica data file (if needed).
          Since Nix only supports integers up to 64 bits, you need to pass a string to this if the cluster ID can't fit in 64 bits.
          Otherwise, you can pass the cluster ID as either an integer or a string.
        '';
      };

      replicaIndex = mkOption {
        type = types.ints.unsigned;
        default = 0;
        description = ''
          The index (starting at 0) of the replica in the cluster.
        '';
      };

      replicaCount = mkOption {
        type = types.ints.unsigned;
        default = 1;
        description = ''
          The number of replicas participating in replication of the cluster.
        '';
      };

      cacheGridSize = mkOption {
        type = types.strMatching "[0-9]+(K|M|G)B";
        default = "1GB";
        description = ''
          The grid cache size.
          The grid cache acts like a page cache for TigerBeetle.
          It is recommended to set this as large as possible.
        '';
      };

      addresses = mkOption {
        type = types.listOf types.nonEmptyStr;
        default = [ "3001" ];
        description = ''
          The addresses of all replicas in the cluster.
          This should be a list of IPv4/IPv6 addresses with port numbers.
          Either the address or port number (but not both) may be omitted, in which case a default of 127.0.0.1 or 3001 will be used.
          The first address in the list corresponds to the address for replica 0, the second address for replica 1, and so on.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      let
        numAddresses = builtins.length cfg.addresses;
      in
      [
        {
          assertion = cfg.replicaIndex < cfg.replicaCount;
          message = "the TigerBeetle replica index must fit the configured replica count";
        }
        {
          assertion = cfg.replicaCount == numAddresses;
          message = if cfg.replicaCount < numAddresses then "TigerBeetle must not have more addresses than the configured number of replicas" else "TigerBeetle must be configured with the addresses of all replicas";
        }
      ];

    systemd.services.tigerbeetle =
      let
        replicaDataPath = "/var/lib/tigerbeetle/${builtins.toString cfg.clusterId}_${builtins.toString cfg.replicaIndex}.tigerbeetle";
      in
      {
        description = "TigerBeetle server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        preStart = ''
          if ! test -e "${replicaDataPath}"; then
            ${lib.getExe cfg.package} format --cluster="${builtins.toString cfg.clusterId}" --replica="${builtins.toString cfg.replicaIndex}" --replica-count="${builtins.toString cfg.replicaCount}" "${replicaDataPath}"
          fi
        '';

        serviceConfig = {
          Type = "exec";

          DynamicUser = true;
          ProtectHome = true;
          DevicePolicy = "closed";

          StateDirectory = "tigerbeetle";
          StateDirectoryMode = 700;

          ExecStart = "${lib.getExe cfg.package} start --cache-grid=${cfg.cacheGridSize} --addresses=${lib.escapeShellArg (builtins.concatStringsSep "," cfg.addresses)} ${replicaDataPath}";
        };
      };

    environment.systemPackages = [ cfg.package ];
  };
}

{ config, lib, pkgs, ... }:

let
  cfg = config.services.dae;
  assets = cfg.assets;
  genAssetsDrv = paths: pkgs.symlinkJoin {
    name = "dae-assets";
    inherit paths;
  };
in
{
  meta.maintainers = with lib.maintainers; [ pokon548 oluceps ];

  options = {
    services.dae = with lib;{
      enable = mkEnableOption
        (mdDoc "A Linux high-performance transparent proxy solution based on eBPF");

      package = mkPackageOptionMD pkgs "dae" { };

      assets = mkOption {
        type = with types;(listOf path);
        default = with pkgs; [ v2ray-geoip v2ray-domain-list-community ];
        defaultText = literalExpression "with pkgs; [ v2ray-geoip v2ray-domain-list-community ]";
        description = mdDoc ''
          Assets required to run dae.
        '';
      };

      assetsPath = mkOption {
        type = types.str;
        default = "${genAssetsDrv assets}/share/v2ray";
        defaultText = literalExpression ''
          (symlinkJoin {
              name = "dae-assets";
              paths = assets;
          })/share/v2ray
        '';
        description = mdDoc ''
          The path which contains geolocation database.
          This option will override `assets`.
        '';
      };

      openFirewall = mkOption {
        type = with types; submodule {
          options = {
            enable = mkEnableOption "enable";
            port = mkOption {
              type = types.int;
              description = ''
                Port to be opened. Consist with field `tproxy_port` in config file.
              '';
            };
          };
        };
        default = {
          enable = true;
          port = 12345;
        };
        defaultText = literalExpression ''
          {
            enable = true;
            port = 12345;
          }
        '';
        description = mdDoc ''
          Open the firewall port.
        '';
      };

      configFile = mkOption {
        type = types.path;
        default = "/etc/dae/config.dae";
        example = "/path/to/your/config.dae";
        description = mdDoc ''
          The path of dae config file, end with `.dae`.
        '';
      };

      config = mkOption {
        type = types.str;
        default = ''
          global{}
          routing{}
        '';
        description = mdDoc ''
          Config text for dae.

          See <https://github.com/daeuniverse/dae/blob/main/example.dae>.
        '';
      };

      disableTxChecksumIpGeneric =
        mkEnableOption (mdDoc "See <https://github.com/daeuniverse/dae/issues/43>");

    };
  };

  config = lib.mkIf cfg.enable

    {
      environment.systemPackages = [ cfg.package ];
      systemd.packages = [ cfg.package ];

      environment.etc."dae/config.dae" = {
        mode = "0400";
        source = pkgs.writeText "config.dae" cfg.config;
      };

      networking = lib.mkIf cfg.openFirewall.enable {
        firewall =
          let portToOpen = cfg.openFirewall.port;
          in
          {
            allowedTCPPorts = [ portToOpen ];
            allowedUDPPorts = [ portToOpen ];
          };
      };

      systemd.services.dae =
        let
          daeBin = lib.getExe cfg.package;
          TxChecksumIpGenericWorkaround = with lib;(getExe pkgs.writeShellApplication {
            name = "disable-tx-checksum-ip-generic";
            text = with pkgs; ''
              iface=$(${iproute2}/bin/ip route | ${lib.getExe gawk} '/default/ {print $5}')
              ${lib.getExe ethtool} -K "$iface" tx-checksum-ip-generic off
            '';
          });
        in
        {
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStartPre = [ "" "${daeBin} validate -c ${cfg.configFile}" ]
              ++ (with lib; optional cfg.disableTxChecksumIpGeneric TxChecksumIpGenericWorkaround);
            ExecStart = [ "" "${daeBin} run --disable-timestamp -c ${cfg.configFile}" ];
            Environment = "DAE_LOCATION_ASSET=${cfg.assetsPath}";
          };
        };

      assertions = [
        {
          assertion = lib.pathExists (toString (genAssetsDrv cfg.assets) + "/share/v2ray");
          message = ''
            Packages in `assets` has no preset paths included.
            Please set `assetsPath` instead.
          '';
        }

        {
          assertion = !((config.services.dae.config != "global{}\nrouting{}\n")
            && (config.services.dae.configFile != "/etc/dae/config.dae"));
          message = ''
            Option `config` and `configFile` could not be set
            at the same time.
          '';
        }
      ];
    };
}

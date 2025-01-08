{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.dae;
  assets = cfg.assets;
  genAssetsDrv =
    paths:
    pkgs.symlinkJoin {
      name = "dae-assets";
      inherit paths;
    };
in
{
  meta.maintainers = with lib.maintainers; [
    pokon548
    oluceps
  ];

  options = {
    services.dae = {
      enable = lib.mkEnableOption "dae, a Linux high-performance transparent proxy solution based on eBPF";

      package = lib.mkPackageOption pkgs "dae" { };

      assets = lib.mkOption {
        type = with lib.types; (listOf path);
        default = with pkgs; [
          v2ray-geoip
          v2ray-domain-list-community
        ];
        defaultText = lib.literalExpression "with pkgs; [ v2ray-geoip v2ray-domain-list-community ]";
        description = ''
          Assets required to run dae.
        '';
      };

      assetsPath = lib.mkOption {
        type = lib.types.str;
        default = "${genAssetsDrv assets}/share/v2ray";
        defaultText = lib.literalExpression ''
          (symlinkJoin {
              name = "dae-assets";
              paths = assets;
          })/share/v2ray
        '';
        description = ''
          The path which contains geolocation database.
          This option will override `assets`.
        '';
      };

      openFirewall = lib.mkOption {
        type =
          lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "opening {option}`port` in the firewall";
              port = lib.mkOption {
                type = lib.types.port;
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
        defaultText = lib.literalExpression ''
          {
            enable = true;
            port = 12345;
          }
        '';
        description = ''
          Open the firewall port.
        '';
      };

      configFile = lib.mkOption {
        type = with lib.types; (nullOr path);
        default = null;
        example = "/path/to/your/config.dae";
        description = ''
          The path of dae config file, end with `.dae`.
        '';
      };

      config = lib.mkOption {
        type = with lib.types; (nullOr str);
        default = null;
        description = ''
          WARNING: This option will expose store your config unencrypted world-readable in the nix store.
          Config text for dae.

          See <https://github.com/daeuniverse/dae/blob/main/example.dae>.
        '';
      };

      disableTxChecksumIpGeneric = lib.mkEnableOption "" // {
        description = "See <https://github.com/daeuniverse/dae/issues/43>";
      };

    };
  };

  config =
    lib.mkIf cfg.enable

      {
        environment.systemPackages = [ cfg.package ];
        systemd.packages = [ cfg.package ];

        networking = lib.mkIf cfg.openFirewall.enable {
          firewall =
            let
              portToOpen = cfg.openFirewall.port;
            in
            {
              allowedTCPPorts = [ portToOpen ];
              allowedUDPPorts = [ portToOpen ];
            };
        };

        systemd.services.dae =
          let
            daeBin = lib.getExe cfg.package;

            configPath =
              if cfg.configFile != null then cfg.configFile else pkgs.writeText "config.dae" cfg.config;

            TxChecksumIpGenericWorkaround =
              (lib.getExe pkgs.writeShellApplication {
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
              LoadCredential = [ "config.dae:${configPath}" ];
              ExecStartPre = [
                ""
                "${daeBin} validate -c \${CREDENTIALS_DIRECTORY}/config.dae"
              ] ++ (lib.optional cfg.disableTxChecksumIpGeneric TxChecksumIpGenericWorkaround);
              ExecStart = [
                ""
                "${daeBin} run --disable-timestamp -c \${CREDENTIALS_DIRECTORY}/config.dae"
              ];
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
            assertion = !((config.services.dae.config != null) && (config.services.dae.configFile != null));
            message = ''
              Option `config` and `configFile` could not be set
              at the same time.
            '';
          }

          {
            assertion = !((config.services.dae.config == null) && (config.services.dae.configFile == null));
            message = ''
              Either `config` or `configFile` should be set.
            '';
          }
        ];
      };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.godns;

  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.godns = {
    enable = mkEnableOption "GoDNS service";

    package = mkPackageOption pkgs "godns" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
      };

      description = ''
        Configuration for GoDNS. Refer to the [configuration section](1) in the
        GoDNS GitHub repository for details.

        [1]: https://github.com/TimothyYe/godns?tab=readme-ov-file#configuration
      '';

      example = {
        provider = "Cloudflare";
        login_token_file = "$CREDENTIALS_DIRECTORY/login_token";
        domains = [
          {
            domain_name = "example.com";
            sub_domains = [ "foo" ];
          }
        ];
        ipv6_urls = [
          "https://api6.ipify.org"
          "https://ip2location.io/ip"
          "https://v6.ipinfo.io/ip"
        ];
        ip_type = "IPv6";
        interval = 300;
      };
    };

    loadCredential = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "login_token:/path/to/login_token" ];
      description = ''
        This can be used to pass secrets to the systemd service without adding
        them to the nix store.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.godns = {
      description = "GoDNS service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} -c ${settingsFormat.generate "config.yaml" cfg.settings}";
        LoadCredential = cfg.loadCredential;
        Restart = "always";
        RestartSec = "2s";
      };
    };
  };

  meta.maintainers = [ lib.maintainers.michaelvanstraten ];
}

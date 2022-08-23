{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.pict-rs;
in
{
  meta.maintainers = with maintainers; [ happysalada ];
  # Don't edit the docbook xml directly, edit the md and generate it:
  # `pandoc pict-rs.md -t docbook --top-level-division=chapter --extract-media=media -f markdown+smart > pict-rs.xml`
  meta.doc = ./pict-rs.xml;

  options.services.pict-rs = {
    enable = mkEnableOption "pict-rs server";
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/pict-rs";
      description = lib.mdDoc ''
        The directory where to store the uploaded images.
      '';
    };
    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        The IPv4 address to deploy the service to.
      '';
    };
    port = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc ''
        The port which to bind the service to.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.pict-rs = {
      environment = {
        PICTRS_PATH = cfg.dataDir;
        PICTRS_ADDR = "${cfg.address}:${toString cfg.port}";
      };
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "pict-rs";
        ExecStart = "${pkgs.pict-rs}/bin/pict-rs";
      };
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.castsponsorskip;
in
{
  options = {
    services.castsponsorskip = {
      enable = lib.mkEnableOption "castsponsorskip";
      package = lib.mkPackageOption pkgs "castsponsorskip" { };
      config = lib.mkOption {
        type = (pkgs.formats.yaml { }).type;
        default = { };
        example = {
          CSS_SKIP_SPONSORS = false;
        };
        description = "Configuration for the service. List of options all options <https://github.com/gabe565/CastSponsorSkip/blob/main/docs/envs.md>.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.castsponsorskip =
      let
        # Needed, even if empty, to avoid searching for a file in
        # the user home directory, which doesn't exist for
        # dynamic users
        config = (pkgs.formats.yaml cfg.config).generate "config.yaml" { };
      in
      {
        description = "Skip YouTube ads and sponsorships on all local Google Cast devices";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          DynamicUser = true;
          Restart = "always";
          ExecStart = "${lib.getExe cfg.package} --config=${config}";
          TimeoutStopSec = "20s";
        };
      };
  };

  meta = {
    maintainers = with lib.maintainers; [ wariuccio ];
  };
}

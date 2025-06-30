{
  config,
  options,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.gnome.gcr-ssh-agent;
  opts = options.services.gnome.gcr-ssh-agent;
  sshCfg = config.programs.ssh;
  sshOpts = options.programs.ssh;
in
{
  meta = {
    maintainers = lib.teams.gnome.members;
  };

  options = {
    services.gnome.gcr-ssh-agent = {
      enable = lib.mkOption {
        default = config.services.gnome.gnome-keyring.enable;
        defaultText = lib.literalExpression "config.services.gnome.gnome-keyring.enable";
        example = true;
        description = "Whether to enable GCR SSH agent.";
        type = lib.types.bool;
      };

      package = lib.mkPackageOption pkgs "GCR" {
        default = [ "gcr_4" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.singleton {
      assertion = !sshCfg.startAgent;
      message = ''
        `${sshOpts.startAgent}' (defined in ${lib.showFiles sshOpts.startAgent.files}) and `${opts.enable}' (defined in ${lib.showFiles opts.enable.files}) cannot both be enabled at the same time.
        These options conflict because only one SSH agent can be installed at a time.'';
    };

    systemd = {
      packages = [ cfg.package ];
      user.services.gcr-ssh-agent.wantedBy = [ "default.target" ];
      user.sockets.gcr-ssh-agent.wantedBy = [ "sockets.target" ];
    };
  };
}

{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {
      gpm = {
        enable = mkOption {
          default = false;
          description = "
            Whether to enable general purpose mouse daemon.
          ";
        };
        protocol = mkOption {
          default = "ps/2";
          description = "
            Mouse protocol to use.
          ";
        };
      };
    };
  };
in

###### implementation
let
  cfg = config.services.gpm;
  inherit (pkgs.lib) mkIf;

  gpm = pkgs.gpm;
  gpmBin = "${gpm}/sbin/gpm";

  job = {
    name = "gpm";
    job = ''
      description = "General purpose mouse"

      start on udev
      stop on shutdown

      respawn ${gpmBin} -m /dev/input/mice -t ${cfg.protocol} -D &>/dev/null
    '';
  };
in

mkIf cfg.enable {
  require = [
    # ../upstart-jobs/default.nix # config.services.extraJobs
    # /etc/security/console.perms (should be generated ?)
    options
  ];

  services = {
    extraJobs = [job];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.programs.mosh;

in
{
  options.programs.mosh = {
    enable = lib.mkEnableOption "mosh";
    package = lib.mkPackageOption pkgs "mosh" { };
    openFirewall = lib.mkEnableOption "" // {
      description = "Whether to automatically open the necessary ports in the firewall.";
      default = true;
    };
    withUtempter = lib.mkEnableOption "" // {
      description = ''
        Whether to enable libutempter for mosh.

        This is required so that mosh can write to /var/run/utmp (which can be queried with `who` to display currently connected user sessions).
        Note, this will add a guid wrapper for the group utmp!
      '';
      default = true;
    };
    networkTimeout = lib.mkOption {
      description = ''
        How long (in seconds) `mosh-server` will wait to receive an update from
        the client before exiting.  Since `mosh` is very useful for mobile
        clients with intermittent operation and connectivity, its authors
        suggest setting this variable to a high value, such as 604800 (one
        week) or 3592000 (30 days).  Otherwise, `mosh-server` will wait
        indefinitely for a client to reappear.  This is somewhat similar to the
        `TMOUT` variable found in many Bourne shells.  However, it is not a
        login-session inactivity timeout; it only applies to network
        connectivity.
      '';
      default = null;
      type = lib.types.nullOr lib.types.numbers.positive;
      example = 604800;
    };
    signalTimeout = lib.mkOption {
      description = ''
        How long (in seconds) `mosh-server` will ignore `SIGUSR1` while waiting
        to receive an update from the client.  Otherwise, `SIGUSR1` will always
        terminate `mosh-server`.  Users and administrators may implement
        scripts to clean up disconnected Mosh sessions.  With this variable
        set, a user or administrator can issue

            $ pkill -SIGUSR1 mosh-server

        to kill disconnected sessions without killing connected login sessions.
      '';
      default = null;
      type = lib.types.nullOr lib.types.numbers.positive;
      example = 60;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.firewall.allowedUDPPortRanges = lib.optional cfg.openFirewall {
      from = 60000;
      to = 61000;
    };
    security.wrappers = lib.mkIf cfg.withUtempter {
      utempter = {
        source = "${pkgs.libutempter}/lib/utempter/utempter";
        owner = "root";
        group = "utmp";
        setuid = false;
        setgid = true;
      };
    };
    environment.sessionVariables = {
      MOSH_SERVER_NETWORK_TMOUT = cfg.networkTimeout;
      MOSH_SERVER_SIGNAL_TMOUT = cfg.signalTimeout;
    };
  };

  meta.maintainers = [ lib.maintainers.me-and ];
}

import ./make-test-python.nix ({ pkgs, lib, ... }: let
  user = "alice";
in {
  name = "ayatana-indicators";

  meta = {
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };

  nodes.machine = { config, ... }: {
    imports = [
      ./common/auto.nix
      ./common/user-account.nix
    ];

    test-support.displayManager.auto = {
      enable = true;
      inherit user;
    };

    services.xserver = {
      enable = true;
      desktopManager.mate.enable = true;
      displayManager.defaultSession = lib.mkForce "mate";
    };

    services.ayatana-indicators = {
      enable = true;
      packages = with pkgs; [
        ayatana-indicator-messages
      ];
    };

    # Services needed by some indicators
    services.accounts-daemon.enable = true; # messages
  };

  # TODO session indicator starts up in a semi-broken state, but works fine after a restart. maybe being started before graphical session is truly up & ready?
  testScript = { nodes, ... }: let
    runCommandPerIndicatorService = command: lib.strings.concatMapStringsSep "\n" command nodes.machine.systemd.user.targets."ayatana-indicators".wants;
  in ''
    start_all()
    machine.wait_for_x()

    # Desktop environment should reach graphical-session.target
    machine.wait_for_unit("graphical-session.target", "${user}")

    # MATE relies on XDG autostart to bring up the indicators.
    # Not sure *when* XDG autostart fires them up, and awaiting pgrep success seems to misbehave?
    machine.sleep(10)

    # Now check if all indicators were brought up successfully, and kill them for later
  '' + (runCommandPerIndicatorService (service: let serviceExec = builtins.replaceStrings [ "." ] [ "-" ] service; in ''
    machine.succeed("pgrep -f ${serviceExec}")
    machine.succeed("pkill -f ${serviceExec}")
  '')) + ''

    # Ayatana target is the preferred way of starting up indicators on SystemD session, the graphical session is responsible for starting this if it supports them.
    # Mate currently doesn't do this, so start it manually for checking (https://github.com/mate-desktop/mate-indicator-applet/issues/63)
    machine.systemctl("start ayatana-indicators.target", "${user}")
    machine.wait_for_unit("ayatana-indicators.target", "${user}")

    # Let all indicator services do their startups, potential post-launch crash & restart cycles so we can properly check for failures
    # Not sure if there's a better way of awaiting this without false-positive potential
    machine.sleep(10)

    # Now check if all indicator services were brought up successfully
  '' + runCommandPerIndicatorService (service: ''
    machine.wait_for_unit("${service}", "${user}")
  '');
})

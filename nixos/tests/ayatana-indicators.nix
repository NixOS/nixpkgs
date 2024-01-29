import ./make-test-python.nix ({ pkgs, lib, ... }: let
  user = "alice";
in {
  name = "ayatana-indicators";

  meta = {
    maintainers = lib.teams.lomiri.members;
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
        ayatana-indicator-datetime
        ayatana-indicator-messages
      ] ++ (with pkgs.lomiri; [
        lomiri-indicator-network
        telephony-service
      ]);
    };

    # Setup needed by some indicators

    services.accounts-daemon.enable = true; # messages

    # Lomiri-ish setup for Lomiri indicators
    # TODO move into a Lomiri module, once the package set is far enough for the DE to start

    networking.networkmanager.enable = true; # lomiri-network-indicator
    # TODO potentially urfkill for lomiri-network-indicator?

    services.dbus.packages = with pkgs.lomiri; [
      libusermetrics
    ];

    environment.systemPackages = with pkgs.lomiri; [
      lomiri-schemas
    ];

    services.telepathy.enable = true;

    users.users.usermetrics = {
      group = "usermetrics";
      home = "/var/lib/usermetrics";
      createHome = true;
      isSystemUser = true;
    };

    users.groups.usermetrics = { };
  };

  # TODO session indicator starts up in a semi-broken state, but works fine after a restart. maybe being started before graphical session is truly up & ready?
  testScript = { nodes, ... }: let
    runCommandOverServiceList = list: command:
      lib.strings.concatMapStringsSep "\n" command list;

    runCommandOverAyatanaIndicators = runCommandOverServiceList
      (builtins.filter
        (service: !(lib.strings.hasPrefix "lomiri" service || lib.strings.hasPrefix "telephony-service" service))
        nodes.machine.systemd.user.targets."ayatana-indicators".wants);

    runCommandOverAllIndicators = runCommandOverServiceList
      nodes.machine.systemd.user.targets."ayatana-indicators".wants;
  in ''
    start_all()
    machine.wait_for_x()

    # Desktop environment should reach graphical-session.target
    machine.wait_for_unit("graphical-session.target", "${user}")

    # MATE relies on XDG autostart to bring up the indicators.
    # Not sure *when* XDG autostart fires them up, and awaiting pgrep success seems to misbehave?
    machine.sleep(10)

    # Now check if all indicators were brought up successfully, and kill them for later
  '' + (runCommandOverAyatanaIndicators (service: let serviceExec = builtins.replaceStrings [ "." ] [ "-" ] service; in ''
    machine.succeed("pgrep -u ${user} -f ${serviceExec}")
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
  '' + runCommandOverAllIndicators (service: ''
    machine.wait_for_unit("${service}", "${user}")
  '');
})

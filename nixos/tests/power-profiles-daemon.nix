{ pkgs, ... }:

{
  name = "power-profiles-daemon";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ mvnetbiz ];
  };
  nodes.machine =
    { pkgs, ... }:
    {
      security.polkit.enable = true;
      services.power-profiles-daemon.enable = true;
      environment.systemPackages = [
        pkgs.glib
        pkgs.power-profiles-daemon
      ];
    };

  testScript = ''
    def get_profile():
        return machine.succeed(
            """gdbus call --system --dest org.freedesktop.UPower.PowerProfiles --object-path /org/freedesktop/UPower/PowerProfiles \
    --method org.freedesktop.DBus.Properties.Get 'org.freedesktop.UPower.PowerProfiles' 'ActiveProfile'
    """
        )


    def set_profile(profile):
        return machine.succeed(
            """gdbus call --system --dest org.freedesktop.UPower.PowerProfiles --object-path /org/freedesktop/UPower/PowerProfiles \
    --method org.freedesktop.DBus.Properties.Set 'org.freedesktop.UPower.PowerProfiles' 'ActiveProfile' "<'{profile}'>"
    """.format(
                profile=profile
            )
        )


    machine.wait_for_unit("multi-user.target")

    set_profile("power-saver")
    profile = get_profile()
    if not "power-saver" in profile:
        raise Exception("Unable to set power-saver profile")


    set_profile("balanced")
    profile = get_profile()
    if not "balanced" in profile:
        raise Exception("Unable to set balanced profile")

    # test powerprofilectl CLI
    machine.succeed("powerprofilesctl set power-saver")
    profile = get_profile()
    if not "power-saver" in profile:
        raise Exception("Unable to set power-saver profile with powerprofilectl")

    machine.succeed("powerprofilesctl set balanced")
    profile = get_profile()
    if not "balanced" in profile:
        raise Exception("Unable to set balanced profile with powerprofilectl")
  '';
}

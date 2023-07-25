import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "power-profiles-daemon";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ mvnetbiz ];
  };
  nodes.machine = { pkgs, ... }: {
    security.polkit.enable = true;
    services.power-profiles-daemon.enable = true;
    environment.systemPackages = [ pkgs.glib ];
  };

  testScript = ''
    def get_profile():
        return machine.succeed(
            """gdbus call --system --dest net.hadess.PowerProfiles --object-path /net/hadess/PowerProfiles \
    --method org.freedesktop.DBus.Properties.Get 'net.hadess.PowerProfiles' 'ActiveProfile'
    """
        )


    def set_profile(profile):
        return machine.succeed(
            """gdbus call --system --dest net.hadess.PowerProfiles --object-path /net/hadess/PowerProfiles \
    --method org.freedesktop.DBus.Properties.Set 'net.hadess.PowerProfiles' 'ActiveProfile' "<'{profile}'>"
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
  '';
})

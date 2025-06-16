{ lib, ... }:
{
  name = "nordvpn";
  meta.maintainers = with lib.maintainers; [ sanferdsouza ];
  nodes =
    let
      commonConfig = user: {
        # norduserd reads DBUS_SESSION_BUS_ADDRESS which is set by the
        # desktopManager upon user session creation (i.e. login)
        services.xserver.enable = true;
        services.desktopManager.gnome.enable = true;
        services.displayManager.gdm.enable = true;
        services.displayManager.autoLogin = {
          enable = true;
          user = user;
        };
      };
    in
    {
      nada = { ... }: { };
      basic =
        { ... }:
        lib.recursiveUpdate {
          users.users.alice = {
            extraGroups = [ "nordvpn" ];
            isNormalUser = true;
          };
          # default: run nordvpnd as nordvpn:nordvpn
          services.nordvpn.enable = true;
        } (commonConfig "alice");
      userOnly =
        { ... }:
        lib.recursiveUpdate {
          users.users.kanye = {
            extraGroups = [ "nordvpn" ];
            isNormalUser = true;
          };
          # run nordvpnd as kanye:nordvpn
          services.nordvpn = {
            enable = true;
            user = "kanye";
          };
        } (commonConfig "kanye");
      groupOnly =
        { ... }:
        lib.recursiveUpdate {
          users.users.alice = {
            extraGroups = [ "kanye" ];
            isNormalUser = true;
          };
          users.groups.kanye = { };
          # run nordvpnd as nordvpn:kanye
          services.nordvpn = {
            enable = true;
            group = "kanye";
          };
        } (commonConfig "alice");
      userAndGroup =
        { ... }:
        lib.recursiveUpdate {
          users.users.kanye = {
            group = "kanye";
            isNormalUser = true;
          };
          users.groups.kanye = { };
          # run nordvpnd as kanye:kanye
          services.nordvpn = {
            enable = true;
            group = "kanye";
            user = "kanye";
          };
        } (commonConfig "kanye");
    };

  testScript = ''
    class UserGroupTestCase:
      def __init__(self, machine, user, has_nordvpn_usr, has_nordvpn_gp):
        self.machine = machine
        self.user = user
        self.has_nordvpn_usr = has_nordvpn_usr
        self.has_nordvpn_gp = has_nordvpn_gp

      def run(self):
        self.machine.start()
        self.verify_nordvpn_user()
        self.verify_nordvpn_group()
        self.verify_services()

      def verify_nordvpn_user(self):
          if self.has_nordvpn_usr:
            self.machine.succeed("id nordvpn")
          else:
            self.machine.fail("id nordvpn")

      def verify_nordvpn_group(self):
        group_str = self.machine.succeed(f"sudo -u {self.user} groups")
        groups = [x.strip() for x in group_str.split(" ")]
        if self.has_nordvpn_gp:
          assert "nordvpn" in groups, f"nordvpn is not in {groups} but should be"
        else:
          assert "nordvpn" not in groups, f"nordvpn is in {groups} but should not be"

      def verify_services(self):
        self.machine.wait_for_unit("nordvpnd", timeout=60)
        self.machine.wait_for_unit("norduserd", self.user, timeout=60)
        # verify can talk to nordvpnd. give nordvpnd at most 5s to initialize.
        self.machine.wait_until_succeeds("nordvpn status", timeout=5)
        self.machine.succeed("nordvpn status")

    test_cases = [
      UserGroupTestCase(basic, "alice", has_nordvpn_usr=True,  has_nordvpn_gp=True),
      UserGroupTestCase(userOnly, "kanye", has_nordvpn_usr=False, has_nordvpn_gp=True),
      UserGroupTestCase(groupOnly, "alice", has_nordvpn_usr=True,  has_nordvpn_gp=False),
      UserGroupTestCase(userAndGroup, "kanye", has_nordvpn_usr=False, has_nordvpn_gp=False),
    ]

    # NADA
    nada.start()
    nada.wait_for_unit("multi-user.target", timeout=60)
    nada.fail("nordvpnd")
    nada.fail("nordvpn")
    nada.fail("norduserd")

    for test_case in test_cases:
      test_case.run()
  '';
}

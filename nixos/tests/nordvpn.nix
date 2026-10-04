{ lib, pkgs, ... }:
{
  name = "nordvpn";
  meta.maintainers = [ ];
  nodes =
    let
      commonConfig = user: {
        # can inspect a native nftables ruleset
        networking.nftables.enable = true;

        # norduserd reads DBUS_SESSION_BUS_ADDRESS which the
        # desktopManager sets on user session creation (i.e. login)
        services.xserver.enable = true;
        services.desktopManager.plasma6.enable = true;
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
        self.verify_trusted_interfaces()
        self.verify_norduserd_socket()
        self.verify_fileshare_socket()

        self.machine.shutdown()

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
        self.machine.wait_for_unit("norduserd", self.user, timeout=90)
        # verify can talk to nordvpnd. give nordvpnd at most 5s to initialize.
        self.machine.wait_until_succeeds("nordvpn status", timeout=5)
        self.machine.succeed("nordvpn status")

      def verify_trusted_interfaces(self):
        ruleset = self.machine.succeed("${lib.getExe pkgs.nftables} list ruleset")
        trusted_line = next(
          (line for line in ruleset.splitlines() if "trusted interfaces" in line), None
        )
        assert trusted_line is not None, "expected a trusted interfaces rule in the nftables ruleset"
        assert "nordlynx" in trusted_line, f"expected nordlynx to be a trusted interface, got: {trusted_line}"

      def verify_norduserd_socket(self):
        uid = self.machine.succeed(f"id -u {self.user}").strip()
        self.__verify_socket_group(f"/tmp/{uid}-norduserd.sock")

      def verify_fileshare_socket(self):
        self.machine.execute(f"sudo -u {self.user} nordfileshare")
        self.__verify_socket_group("/tmp/fileshare.sock")

      def __verify_socket_group(self, path):
        expected_group = "nordvpn" if self.has_nordvpn_gp else "kanye"
        actual_group, actual_perm = self.machine.succeed(
          f"stat -c '%G %a' {path}"
        ).strip().split()
        assert actual_group == expected_group, f"expected {path} group {expected_group}, got {actual_group}"
        assert actual_perm == "660", f"expected {path} permission 660, got {actual_perm}"

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
    nada.shutdown()

    for test_case in test_cases:
      test_case.run()
  '';
}

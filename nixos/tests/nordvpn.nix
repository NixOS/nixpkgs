{ lib, ... }:
{
  name = "nordvpn";
  meta.maintainers = with lib.maintainers; [ different-error ];
  nodes =
    let
      commonConfig = user: {
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
          users.users.bob = {
            extraGroups = [ "nordvpn" ];
            isNormalUser = true;
          };
          # run nordvpnd as bob:nordvpn
          services.nordvpn = {
            enable = true;
            user = "bob";
          };
        } (commonConfig "bob");
      groupOnly =
        { ... }:
        lib.recursiveUpdate {
          users.users.alice = {
            extraGroups = [ "bob" ];
            isNormalUser = true;
          };
          users.groups.bob = { };
          # run nordvpnd as nordvpn:bob
          services.nordvpn = {
            enable = true;
            group = "bob";
          };
        } (commonConfig "alice");
      userAndGroup =
        { ... }:
        lib.recursiveUpdate {
          users.users.bob = {
            group = "bob";
            isNormalUser = true;
          };
          users.groups.bob = { };
          # run nordvpnd as bob:bob
          services.nordvpn = {
            enable = true;
            group = "bob";
            user = "bob";
          };
        } (commonConfig "bob");
    };

  testScript = ''
    ALICE = "alice"
    BOB = "bob"
    NORDVPN = "nordvpn"
    ALLOWED = [ ALICE, BOB, NORDVPN ]
    KERNEL_MODULES = [ "tun", "wireguard" ]

    def is_in_allowed(s):
      assert s in ALLOWED, f"{s} is not in ALLOWED"

    class UserGroupTestCase:
      def __init__(self, machine, machine_user, nordvpn_user, nordvpn_group):
        self.machine = machine

        self.machine_user = machine_user
        self.nordvpn_user = NORDVPN if nordvpn_user is None else nordvpn_user
        self.nordvpn_group = NORDVPN if nordvpn_group is None else nordvpn_group

        is_in_allowed(self.machine_user)
        is_in_allowed(self.nordvpn_user)
        is_in_allowed(self.nordvpn_group)

      def run(self):
        self.machine.start()
        self.verify_nordvpn_user()
        self.verify_nordvpn_group()
        self.verify_services()
        self.verify_polkit_rules()
        self.verify_kernel_modules_loaded()

        # nordvpnd related tests
        self.verify_nordvpnd_process_ownership()
        self.verify_nordvpnd_process_capabilities()
        self.verify_nordvpnd_can_access_tun()
        self.verify_nordvpnd_runtime_directory()
        self.verify_nordvpnd_state_directory()

        self.machine.shutdown()

      def verify_nordvpn_user(self):
          if self.nordvpn_user == NORDVPN:
            self.machine.succeed("id nordvpn")
          else:
            self.machine.fail("id nordvpn")

      def verify_nordvpn_group(self):
        group_str = self.machine.succeed(f"sudo -u {self.machine_user} groups")
        groups = [x.strip() for x in group_str.split(" ")]
        if self.nordvpn_group == NORDVPN:
          assert NORDVPN in groups, f"{NORDVPN} is not in {groups} but should be"
        else:
          assert NORDVPN not in groups, f"{NORDVPN} is in {groups} but should not be"

      def verify_services(self):
        self.machine.wait_for_unit("nordvpnd", timeout=60)
        self.machine.wait_for_unit("norduserd", self.machine_user, timeout=90)
        # verify can talk to nordvpnd. give nordvpnd at most 5s to initialize.
        self.machine.wait_until_succeeds("nordvpn status", timeout=5)
        self.machine.succeed("nordvpn status")

      def verify_polkit_rules(self):
        rules = self.machine.succeed("cat /etc/polkit-1/rules.d/10-nixos.rules")
        expected = f'subject.isInGroup("{self.nordvpn_group}")'
        assert expected in rules, f"expected polkit rules to reference group {self.nordvpn_group}"

      def verify_kernel_modules_loaded(self):
        lines = self.machine.succeed("lsmod").splitlines()
        loaded = {line.split()[0] for line in lines[1:] if line.strip()}
        for module in KERNEL_MODULES:
          assert module in loaded, f"expected kernel module {module} to be loaded, got {loaded}"

      def verify_nordvpnd_process_ownership(self):
        pid = self.machine.succeed("pidof nordvpnd").strip()
        user, group = self.machine.succeed(
          f"ps -o user=,group= -p {pid}"
        ).strip().split()
        assert user == self.nordvpn_user, f"expected nordvpnd to run as user {self.nordvpn_user}, got {user}"
        assert group == self.nordvpn_group, f"expected nordvpnd to run as group {self.nordvpn_group}, got {group}"

      def verify_nordvpnd_process_capabilities(self):
        pid = self.machine.succeed("pidof nordvpnd").strip()
        status = self.machine.succeed(f"cat /proc/{pid}/status")
        caps = {}
        for line in status.splitlines():
          if line.startswith("Cap"):
            key, value = line.split(":")
            caps[key.strip()] = int(value.strip(), base=16)

        # CAP_NET_ADMIN (bit 12)
        expected = (1 << 12)
        for cap_set in ["CapAmb", "CapBnd", "CapEff", "CapPrm"]:
          assert caps[cap_set] == expected, (
            f"expected {cap_set} to be exactly CAP_NET_ADMIN"
            f"({expected:#x}), got {caps[cap_set]:#x}"
          )

      def verify_nordvpnd_can_access_tun(self):
        cgroup = self.machine.get_unit_property("nordvpnd", "ControlGroup").strip()

        # enter the cgroup of nordvpnd service and verify access to /dev/net/tun
        self.machine.succeed(
          f"sh -c 'echo $$ > /sys/fs/cgroup{cgroup}/cgroup.procs && exec 3<>/dev/net/tun'"
        )

      def verify_nordvpnd_runtime_directory(self):
        self.__verify_group_and_permissions("/run/nordvpn", perm="750")

      def verify_nordvpnd_state_directory(self):
        self.__verify_group_and_permissions("/var/lib/nordvpn", perm="750")

      def __verify_group_and_permissions(self, path, perm):
        # has the correct group
        actual_group, actual_perm = self.machine.succeed(
          f"stat -c '%G %a' {path}"
        ).strip().split()
        assert actual_group == self.nordvpn_group, f"expected {path} group {self.nordvpn_group}, got {actual_group}"

        # has correct permissions
        assert actual_perm == perm, f"expected {path} permission {perm}, got {actual_perm}"

    test_cases = [
      UserGroupTestCase(basic, machine_user=ALICE, nordvpn_user=None,  nordvpn_group=None),
      UserGroupTestCase(userOnly, machine_user=BOB, nordvpn_user=BOB, nordvpn_group=None),
      UserGroupTestCase(groupOnly, machine_user=ALICE, nordvpn_user=None,  nordvpn_group=BOB),
      UserGroupTestCase(userAndGroup, machine_user=BOB, nordvpn_user=BOB, nordvpn_group=BOB),
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

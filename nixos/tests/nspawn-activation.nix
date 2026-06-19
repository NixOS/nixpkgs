# Regression test for `switch-to-configuration` activation in tests run in
# nspawn: activation completion + non-privileged invariants.
#
# In tests run in nspawn, activation runs in an unprivileged build sandbox
# (`boot.sandboxedActivation = true`), so `switch-to-configuration`
# skips a few root-only operations it would otherwise perform:
#
#   * `suid-sgid-wrappers.service` would run `setcap` / `chmod u+s` -- the
#     mapped-uid root can't set capabilities or `S_ISUID`.
#   * `resolvconf.service` would run `setfacl /run/resolvconf` -- the noacl
#     `/run` tmpfs returns ENOTSUP.
#
# This declares a setuid wrapper and resolvconf, then asserts a real
# `switch-to-configuration test` exits 0 and the wrapper can be invoked.
#
# It also asserts the fidelity gap directly: the wrapper is non-setuid and
# cap-less here, so a test that needs real privilege escalation (setuid,
# `sudo`, file capabilities, ACLs) must use the QEMU driver, not nspawn.
{ ... }:
{
  name = "nspawn-activation";

  containers.machine =
    { pkgs, ... }:
    {
      system.switch.enable = true;

      # `getcap`, to assert the wrapper is cap-less under the sandbox.
      environment.systemPackages = [ pkgs.libcap.out ];

      # A setuid wrapper: its activation runs `chmod u+s` + `setcap`, the ops
      # that fail under the sandboxed-container user namespace.
      security.wrappers.test-wrapper = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.coreutils}/bin/true";
      };

      # test `setfacl` on the container's noacl `/run` tmpfs
      networking.resolvconf.enable = true;
    };

  testScript =
    { containers, ... }:
    let
      toplevel = containers.machine.system.build.toplevel;
    in
    # python
    ''
      machine.start()
      machine.wait_for_unit("multi-user.target", timeout=120)

      # quick test of `switch-to-configuration` without a real new generation
      status, out = machine.execute(
          "timeout 90 ${toplevel}/bin/switch-to-configuration test 2>&1",
          check_return=False,
          timeout=120,
      )
      machine.log(f"switch-to-configuration test: status={status}\n{out}")
      assert status == 0, (
          f"switch-to-configuration activation failed under nspawn "
          f"(status={status}). A privileged activation op was refused by the "
          "build sandbox's user namespace / noacl /run -- `suid-sgid-wrappers` "
          "(chmod u+s / setcap on /run/wrappers) or `resolvconf` (setfacl on "
          "/run/resolvconf). Never observed on QEMU.\n" + out[-2000:]
      )

      # The wrapper exists, is executable, and can be invoked.
      machine.succeed("test -x /run/wrappers/bin/test-wrapper")
      machine.succeed("/run/wrappers/bin/test-wrapper")

      # Fidelity limit: under the sandbox the wrapper is non-setuid and
      # cap-less. Asserting this keeps the test from being a false success --
      # real privilege escalation is out of scope here, use the QEMU driver.
      machine.succeed("! test -u /run/wrappers/bin/test-wrapper")
      machine.succeed("! getcap /run/wrappers/bin/test-wrapper | grep -q cap_")
    '';
}

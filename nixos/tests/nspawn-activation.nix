# Regression test for an nspawn-only `switch-to-configuration` activation
# failure.
#
# Trigger
# -------
# Inside an unprivileged systemd-nspawn test container (the NixOS test nspawn
# backend, nixpkgs #478109: `--keep-unit --register=no --private-users=no`, run
# inside the Nix build sandbox's user namespace), a real
# `switch-to-configuration test` exits `status 4/NOPERMISSION` because two
# activation services hit privileged operations the sandbox forbids, even with
# the bus and routes healthy:
#
#   * `suid-sgid-wrappers.service` runs `setcap` / `chmod u+s` on the wrappers;
#     the container's "root" is a mapped uid with no real privilege, so the
#     kernel refuses `S_ISUID` (`chmod u+s` -> `Operation not permitted`) and
#     `setcap` returns `Operation not supported`.
#   * `resolvconf.service` runs `setfacl /run/resolvconf`; the tmpfs backing the
#     container `/run` is effectively `noacl`, so it returns `ENOTSUP`.
#
# A build-time skip of those ops (keyed on `boot.isNspawnContainer`) lets
# activation finish, but then leaves a wrapper that aborts at *invocation*: the
# runtime security-wrapper queries its own `security.capability` xattr via
# `getxattr("/proc/self/exe", ...)` and fails with `Not supported` on the same
# noxattr store. The fix treats that `ENOTSUP`/`ENOSYS` exactly like the
# existing `ENODATA` "none set" path.
#
# What this test asserts
# ----------------------
# Boot one nspawn container that declares a setuid wrapper and enables
# resolvconf, then run the booted system's own `switch-to-configuration test`
# once and assert it exits 0 -- and that the resulting setuid wrapper can still
# be *invoked* (exercises the runtime `wrapper.c` getxattr path). RED before the
# fix (activation exits 4, or the wrapper aborts on invocation), GREEN with it.
# This is **nspawn-specific**: a QEMU VM has its own kernel and runs outside the
# build sandbox's privilege constraints, so the identical activation succeeds
# there.
{ ... }:
{
  name = "nspawn-activation";

  containers.machine =
    { pkgs, ... }:
    {
      system.switch.enable = true;

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
    '';
}

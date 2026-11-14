{ lib, ... }:

{
  name = "sysfs";
  meta.maintainers = [ ];

  nodes.machine = {
    boot.kernel.sysfs = {
      kernel.mm.transparent_hugepage = {
        enabled = "always";
        defrag = "defer";
        shmem_enabled = "within_size";
      };

      block."*".queue.scheduler = "none";
    };

    # Second generation with a changed value, to check that sysfs attribute
    # changes are also applied on configuration switches, not only at boot.
    specialisation.changed-sysfs.configuration = {
      boot.kernel.sysfs.kernel.mm.transparent_hugepage.enabled = lib.mkForce "madvise";
    };
  };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.boot.kernel) sysfs;
    in
    ''
      from shlex import quote

      def check(filename, contents):
        machine.succeed('grep -F -q {} {}'.format(quote(contents), quote(filename)))

      check('/sys/kernel/mm/transparent_hugepage/enabled',
        '[${sysfs.kernel.mm.transparent_hugepage.enabled}]')
      check('/sys/kernel/mm/transparent_hugepage/defrag',
        '[${sysfs.kernel.mm.transparent_hugepage.defrag}]')
      check('/sys/kernel/mm/transparent_hugepage/shmem_enabled',
        '[${sysfs.kernel.mm.transparent_hugepage.shmem_enabled}]')

      with subtest("apply changed sysfs attributes on switch"):
        machine.succeed('/run/current-system/specialisation/changed-sysfs/bin/switch-to-configuration switch')
        check('/sys/kernel/mm/transparent_hugepage/enabled',
          '[madvise]')
    '';
}

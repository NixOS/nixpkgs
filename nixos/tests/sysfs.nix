{ lib, ... }:

{
  name = "sysfs";
  meta.maintainers = with lib.maintainers; [ mvs ];

  nodes.machine = {
    boot.kernel.sysfs = {
      kernel.mm.transparent_hugepage = {
        enabled = "always";
        defrag = "defer";
        shmem_enabled = "within_size";
      };

      block."*".queue.scheduler = "none";
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
    '';
}

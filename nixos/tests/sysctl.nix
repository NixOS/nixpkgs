{ lib, ... }:
{
  name = "sysctl";
  meta.maintainers = with lib.maintainers; [ mvs ];
  nodes.machine = {
    boot.kernel.sysctl = {
      net.core = {
        bpf_jit_enable = 1;
        bpf_jit_harden = 2;
      };

      net.ipv4.conf."eth[0-9]*".log_martians = true;
    };
  };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.boot.kernel) sysctl;
    in
    ''
      from shlex import quote
      def check(filename, contents):
        machine.succeed('grep -F -q {} {}'.format(quote(contents), quote(filename)))

      check('/proc/sys/net/core/bpf_jit_enable', '${toString sysctl.net.core.bpf_jit_enable}')
      check('/proc/sys/net/core/bpf_jit_harden', '${toString sysctl.net.core.bpf_jit_harden}')
      check('/proc/sys/net/ipv4/conf/eth0/log_martians', '1')
    '';
}

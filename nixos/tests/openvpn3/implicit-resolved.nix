import ../make-test-python.nix (
  { pkgs, ... }:
  {
    name = "openvpn3-implicit-resolved";
    meta.maintainers = [ pkgs.lib.maintainers.progrm_jarvis ];

    nodes.machine = _: {
      services.resolved.enable = true;
      programs.openvpn3.enable = true;
    };

    testScript = ''
      import json

      start_all()
      machine.wait_for_file('/etc/openvpn3/netcfg.json')
      machine.wait_for_file('/etc/openvpn3/log-service.json')
      machine.succeed('openvpn3 version')

      netcfg = json.loads(machine.succeed('cat /etc/openvpn3/netcfg.json'))
      assert netcfg['systemd_resolved']

      netcfg_service_config = machine.succeed('sudo openvpn3-admin netcfg-service --config-show').splitlines()
      assert 'Loading configuration file: /etc/openvpn3/netcfg.json' in netcfg_service_config
      assert 'Systemd-resolved in use: Yes' in netcfg_service_config
    '';
  }
)

import ../make-test-python.nix (
  { pkgs, ... }:
  {
    name = "openvpn3-simple";
    meta.maintainers = [ pkgs.lib.maintainers.progrm_jarvis ];

    nodes.machine = _: {
      programs.openvpn3.enable = true;
    };

    testScript = ''
      import json

      start_all()
      machine.wait_for_file('/etc/openvpn3/netcfg.json')
      machine.wait_for_file('/etc/openvpn3/log-service.json')
      machine.succeed('openvpn3 version')

      netcfg = json.loads(machine.succeed('cat /etc/openvpn3/netcfg.json'))
      assert 'systemd_resolved' not in netcfg

      netcfg_service_config = machine.succeed('sudo openvpn3-admin netcfg-service --config-show').splitlines()
      assert 'Loading configuration file: /etc/openvpn3/netcfg.json' in netcfg_service_config
      assert 'Configuration file is empty' in netcfg_service_config
    '';
  }
)

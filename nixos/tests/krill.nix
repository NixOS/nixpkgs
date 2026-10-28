{ pkgs, lib, ... }:

{
  name = "krill";

  meta = {
    maintainers = [ lib.maintainers.stepbrobd ];
    teams = [ lib.teams.ngi ];
  };

  nodes.machine = {
    services.krill = {
      enable = true;
      settings = {
        admin_token = "krill-nixos-test";
        # VM have no internet
        bgp_riswhois_enabled = false;
        # embedded trust anchor
        testbed = {
          ta_aia = "rsync://krill.test/ta/ta.cer";
          ta_uri = "https://krill.test/ta/ta.cer";
          rrdp_base_uri = "https://krill.test/rrdp/";
          rsync_jail = "rsync://krill.test/repo/";
        };
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("krill.service")
    machine.wait_for_open_port(3000)

    machine.wait_until_succeeds("krillc health")

    assert "${pkgs.krill.version}" in machine.succeed("krillc info")

    machine.wait_until_succeeds("krillc show --ca testbed")
  '';
}

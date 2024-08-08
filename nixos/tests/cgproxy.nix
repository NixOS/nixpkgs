import ./make-test-python.nix ({ lib, pkgs, ... }: {

  name = "cgproxy";

  meta = {
    maintainers = with lib.maintainers; [ oluceps ];
  };

  nodes.machine = { pkgs, ... }: {
    services.cgproxy = {
      enable = true;
      settings = {
        cgroup_noproxy = [ ];
        cgroup_proxy = [ ];
        enable_dns = true;
        enable_gateway = false;
        enable_ipv4 = true;
        enable_ipv6 = true;
        enable_tcp = true;
        enable_udp = true;
        fwmark = 39283;
        port = 12345;
        program_noproxy = [ ];
        program_proxy = [ ];
        table = 10007;
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("cgproxy.service")
  '';

})

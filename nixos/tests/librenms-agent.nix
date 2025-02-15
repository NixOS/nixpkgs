let
  host = "127.0.0.1";
  port = 6557;
in import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "librenms-agent";

  nodes.librenms-agent = {
    environment.systemPackages = with pkgs; [
      inetutils
    ];

    services.librenms-agent = {
      enable = true;
      port = port;
      ipAddressAllow = [ host ];
      openFirewall = true;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("sockets.target")
    machine.succeed("telnet ${host} ${toString port} | grep AgentOS");
  '';
})

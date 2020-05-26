import ./make-test.nix ({ pkgs, lib, ... }: {
  name = "dynomite";
  meta.maintainers = [ lib.maintainers.Scriptkiddi ];

  machine =
    { ... }:
    {
      virtualisation.memorySize = 1024;
      environment.systemPackages = with pkgs; [ redis dynomite ];
      services.dynomite = {
        enable = true;
        settings = {
          dyn_o_mite = {
            listen = "127.0.0.1:8102";
            dyn_listen = "127.0.0.1:8101";
            tokens = "101134286";
            servers = [
              "127.0.0.1:6379:1"
              ];
            data_store =  0;
            mbuf_size = 16384;
            max_msgs = 300000;
          };
        };
      };
    };

  testScript = ''
    startAll()
    machine.wait_for_unit('redis.service')
    machine.wait_for_unit('dynomite.service')
    machine.succeed('redis-cli -p 8102 ping')
    machine.succeed('dynomite --test-conf -c $(systemctl cat dynomite | grep ExecStart | cut -d"=" -f3) ')
  '';
})

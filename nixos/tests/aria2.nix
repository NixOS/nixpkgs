import ./make-test-python.nix ({ pkgs, ... }:
let
  rpcSecret = "supersecret";
  rpc-listen-port = 6800;
  curlBody = {
    jsonrpc = 2.0;
    id = 1;
    method = "aria2.getVersion";
    params = [ "token:${rpcSecret}" ];
  };
in
rec {
  name = "aria2";

  nodes.machine = {
    environment.etc."aria2Rpc".text = rpcSecret;
    services.aria2 = {
      enable = true;
      rpcSecretFile = "/etc/aria2Rpc";
      settings = {
        inherit rpc-listen-port;
        allow-overwrite = false;
        check-integrity = true;
        console-log-level = "warn";
        listen-port = [{ from = 20000; to = 20010; } { from = 22222; to = 22222; }];
        max-concurrent-downloads = 50;
        seed-ratio = 1.2;
        summary-interval = 0;
      };
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("aria2.service")
    curl_cmd = 'curl --fail-with-body -X POST -H "Content-Type: application/json" \
                -d \'${builtins.toJSON curlBody}\' http://localhost:${toString rpc-listen-port}/jsonrpc'
    print(machine.wait_until_succeeds(curl_cmd, timeout=10))
    machine.shutdown()
  '';

  meta.maintainers = [ pkgs.lib.maintainers.timhae ];
})

{ pkgs, lib, ... }:
let
  rpcSecret = "supersecret";
  rpcPort = 6800;

  curlBody = {
    jsonrpc = "2.0";
    id = 1;
    method = "aria2.getVersion";
    params = [ "token:${rpcSecret}" ];
  };

  addUriBody = {
    jsonrpc = "2.0";
    id = 2;
    method = "aria2.addUri";
    params = [
      "token:${rpcSecret}"
      [ "http://localhost/index.html" ]
      {
        dir = "/tmp";
        out = "test-download.txt";
      }
    ];
  };

  getGlobalStatBody = {
    jsonrpc = "2.0";
    id = 4;
    method = "aria2.getGlobalStat";
    params = [ "token:${rpcSecret}" ];
  };

  xmlRpcBody = pkgs.writeText "rpc-body.xml" ''
    <?xml version="1.0"?>
    <methodCall>
      <methodName>aria2.getVersion</methodName>
      <params>
        <param>
          <value><string>token:${rpcSecret}</string></value>
        </param>
      </params>
    </methodCall>
  '';
in
{
  name = "aria2-next";

  nodes.machine = { pkgs, ... }: {
    environment.etc."aria2Rpc".text = rpcSecret;

    services.nginx = {
      enable = true;
      virtualHosts."localhost" = {
        root = pkgs.writeTextDir "index.html" "<html><body>Test</body></html>";
        locations."/" = {
          tryFiles = "$uri $uri/ =404";
        };
      };
    };

    services.aria2 = {
      enable = true;
      package = pkgs.aria2-next;
      rpcSecretFile = "/etc/aria2Rpc";
      settings = {
        enable-rpc = true;
        rpc-listen-port = rpcPort;
        allow-overwrite = false;
        check-integrity = true;
        console-log-level = "warn";
        listen-port = [
          {
            from = 20000;
            to = 20010;
          }
          {
            from = 22222;
            to = 22222;
          }
        ];
        max-concurrent-downloads = 50;
        seed-ratio = 1.2;
        summary-interval = 0;
      };
    };

    environment.systemPackages = with pkgs; [ curl ];
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("aria2.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(${toString rpcPort})

    print("Testing JSON-RPC getVersion...")
    curl_cmd = 'curl --fail-with-body -X POST -H "Content-Type: application/json" \
                -d \'${builtins.toJSON curlBody}\' http://localhost:${toString rpcPort}/jsonrpc'
    response = machine.wait_until_succeeds(curl_cmd)
    assert '"result"' in response, f"getVersion: no result in {response!r}"
    assert '"error"' not in response, f"getVersion: error in {response!r}"
    print(f"getVersion response: {response}")

    print("Testing XML-RPC getVersion...")
    xml_cmd = 'curl --fail-with-body -X POST -H "Content-Type: application/xml" \
               -d @${xmlRpcBody} http://localhost:${toString rpcPort}/rpc'
    xml_response = machine.wait_until_succeeds(xml_cmd)
    assert "<methodResponse>" in xml_response, \
        f"XML-RPC: no <methodResponse> in {xml_response!r}"
    assert "<name>version</name>" in xml_response, \
        f"XML-RPC: no version field in {xml_response!r}"
    print(f"XML-RPC response: {xml_response}")

    print("Testing HTTP download...")
    add_cmd = 'curl --fail-with-body -X POST -H "Content-Type: application/json" \
               -d \'${builtins.toJSON addUriBody}\' http://localhost:${toString rpcPort}/jsonrpc'
    add_response = machine.succeed(add_cmd)
    assert '"result"' in add_response, f"addUri: no result in {add_response!r}"
    assert '"error"' not in add_response, f"addUri: error in {add_response!r}"
    print(f"addUri response: {add_response}")
    machine.wait_until_succeeds("test -f /tmp/test-download.txt")
    machine.wait_until_succeeds("grep -q 'Test' /tmp/test-download.txt")
    print("Download completed successfully")

    print("Testing getGlobalStat...")
    stat_cmd = 'curl --fail-with-body -X POST -H "Content-Type: application/json" \
                -d \'${builtins.toJSON getGlobalStatBody}\' http://localhost:${toString rpcPort}/jsonrpc'
    stat_response = machine.succeed(stat_cmd)
    assert '"result"' in stat_response, f"getGlobalStat: no result in {stat_response!r}"
    assert '"error"' not in stat_response, f"getGlobalStat: error in {stat_response!r}"
    print(f"Global stat: {stat_response}")

    print("Testing graceful shutdown...")
    machine.succeed("systemctl stop aria2.service")
    machine.wait_until_fails("systemctl is-active --quiet aria2.service")
    print("Service stopped cleanly")

    machine.shutdown()
  '';

  meta.maintainers = with lib.maintainers; [ ProxyVT ];
}

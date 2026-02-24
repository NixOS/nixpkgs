{ pkgs, lib, ... }:
{
  name = "netbird";

  meta.maintainers = with pkgs.lib.maintainers; [
    nazarewk
  ];

  nodes = {
    node = {
      services.netbird = {
        enable = true;
        clients.custom.port = 51819;
        ui.enable = true;

        # Test advanced options
        clients.advanced = {
          port = 51830;
          dns.disable = true;
          routing.blockLanAccess = true;
          mtu = 1280;
          debug.anonymizeLogs = true;
        };

        # Test SSH and security options
        clients.withSsh = {
          port = 51831;
          ssh.enable = true;
          ssh.sftp.enable = true;
          rosenpass.enable = true;
          rosenpass.permissive = true;
        };

        # Test connection and server options
        clients.selfhosted = {
          port = 51832;
          connection.lazy = true;
          connection.networkMonitor = false;
          server.managementUrl = "https://management.example.com:443";
          hostname = "test-peer";
        };
      };
    };
  };

  /*
    Historically waiting for the NetBird client daemon initialization helped catch number of bugs with the service,
     so we keep try to keep it here in as much details as it makes sense.

    Initially `netbird status` returns a "Disconnected" messages:
        OS: linux/amd64
        Daemon version: 0.54.0
        CLI version: 0.54.0
        Profile: default
        Management: Disconnected, reason: rpc error: code = FailedPrecondition desc = failed connecting to Management Service : context deadline exceeded
        Signal: Disconnected
        Relays: 0/0 Available
        Nameservers: 0/0 Available
        FQDN:
        NetBird IP: N/A
        Interface type: N/A
        Quantum resistance: false
        Lazy connection: false
        Networks: -
        Forwarding rules: 0
        Peers count: 0/0 Connected

    After a while passes it should start returning "NeedsLogin" help message.

    As of ~0.53.0+ in ~30 second intervals the `netbird status` instead of "NeedsLogin" it briefly (for under 2 seconds) crashes with:

        Error: status failed: failed connecting to Management Service : context deadline exceeded

    This might be related to the following log line:

        2025-08-11T15:03:25Z ERRO shared/management/client/grpc.go:65: failed creating connection to Management Service: context deadline exceeded
  */
  # TODO: confirm the whole solution is working end-to-end when netbird server is implemented
  testScript = ''
    import textwrap
    import time

    start_all()

    def run_with_debug(node, cmd, check=True, display=True, **kwargs):
      cmd = f"{cmd} 2>&1"
      start = time.time()
      ret, output = node.execute(cmd, **kwargs)
      duration = time.time() - start
      txt = f">>> {cmd=} {ret=} {duration=:.2f}:\n{textwrap.indent(output, '... ')}"
      if check:
        assert ret == 0, txt
      if display:
        print(txt)
      return ret, output

    def wait_until_rcode(node, cmd, rcode=0, retries=30, **kwargs):
      def check_success(_last_try):
        nonlocal output
        ret, output = run_with_debug(node, cmd, **kwargs)
        return ret == rcode

      kwargs.setdefault('check', False)
      output = None
      with node.nested(f"waiting for {cmd=} to exit with {rcode=}"):
          retry(check_success, retries)
          return output

    instances = ["netbird", "netbird-custom", "netbird-advanced", "netbird-withSsh", "netbird-selfhosted"]

    for name in instances:
      node.wait_for_unit(f"{name}.service")
      node.wait_for_file(f"/var/run/{name}/sock")

    for name in instances:
      wait_until_rcode(node, f"{name} status |& grep -C20 Disconnected", 0, retries=5)

    # Verify environment variables are set correctly for advanced client
    node.succeed("systemctl show netbird-advanced.service --property=Environment | grep -q NB_DISABLE_DNS=true")
    node.succeed("systemctl show netbird-advanced.service --property=Environment | grep -q NB_BLOCK_LAN_ACCESS=true")
    node.succeed("systemctl show netbird-advanced.service --property=Environment | grep -q NB_ANONYMIZE=true")

    # Verify environment variables for SSH client
    node.succeed("systemctl show netbird-withSsh.service --property=Environment | grep -q NB_ALLOW_SERVER_SSH=true")
    node.succeed("systemctl show netbird-withSsh.service --property=Environment | grep -q NB_SSH_ALLOW_SFTP=true")
    node.succeed("systemctl show netbird-withSsh.service --property=Environment | grep -q NB_ENABLE_ROSENPASS=true")
    node.succeed("systemctl show netbird-withSsh.service --property=Environment | grep -q NB_ROSENPASS_PERMISSIVE=true")

    # Verify environment variables for selfhosted client
    node.succeed("systemctl show netbird-selfhosted.service --property=Environment | grep -q NB_ENABLE_LAZY_CONNECTION=true")
    node.succeed("systemctl show netbird-selfhosted.service --property=Environment | grep -q NB_DISABLE_NETWORK_MONITOR=true")
    node.succeed("systemctl show netbird-selfhosted.service --property=Environment | grep -q NB_HOSTNAME=test-peer")

    # Verify config.json contains MTU and ManagementURL
    node.succeed("cat /etc/netbird-advanced/config.d/50-nixos.json | grep -q '\"Mtu\": 1280'")
    node.succeed("cat /etc/netbird-selfhosted/config.d/50-nixos.json | grep -q 'ManagementURL'")
    node.succeed("cat /etc/netbird-selfhosted/config.d/50-nixos.json | grep -q 'management.example.com'")
  ''
  # The status used to turn into `NeedsLogin`, but recently started crashing instead.
  # leaving the snippets in here, in case some update goes back to the old behavior and can be tested again
  + lib.optionalString false ''
    for name in instances:
      #wait_until_rcode(node, f"{name} status |& grep -C20 NeedsLogin", 0, retries=20)
      output = wait_until_rcode(node, f"{name} status", 1, retries=61)
      msg = "Error: status failed: failed connecting to Management Service : context deadline exceeded"
      assert output.strip() == msg, f"expected {msg=}, got {output=} instead"
      wait_until_rcode(node, f"{name} status |& grep -C20 Disconnected", 0, retries=10)
  '';
}

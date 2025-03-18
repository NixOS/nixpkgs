{ pkgs, lib, ... }:
let
  tls_chain = "${./common/acme/server}/ca.cert.pem";
  tls_key = "${./common/acme/server}/ca.key.pem";
in
{
  name = "netbird";

  meta.maintainers = with pkgs.lib.maintainers; [
    patrickdag
    nazarewk
  ];

  nodes = {
    node =
      { ... }:
      {
        services.netbird.enable = true;
        services.netbird.clients.custom.port = 51819;
      };
    kanidm = {
      services.kanidm = {
        # needed since default for nixos 24.11
        # is kanidm 1.4.6 which is insecure
        package = pkgs.kanidm_1_5;
        enableServer = true;
        serverSettings = {
          inherit tls_key tls_chain;
          domain = "localhost";
          origin = "https://localhost";
        };
      };
    };
    server =
      { ... }:
      {
        # netbirds needs an openid identity provider
        services.netbird.server = {
          enable = true;
          coturn = {
            enable = true;
            password = "secure-password";
          };
          domain = "nixos-test.internal";
          dashboard.settings.AUTH_AUTHORITY = "https://kanidm/oauth2/openid/netbird";
          management.oidcConfigEndpoint = "https://kanidm:8443/oauth2/openid/netbird/.well-known/openid-configuration";
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

    instances = ["netbird", "netbird-custom"]

    for name in instances:
      node.wait_for_unit(f"{name}.service")
      node.wait_for_file(f"/var/run/{name}/sock")

    for name in instances:
      wait_until_rcode(node, f"{name} status |& grep -C20 Disconnected", 0, retries=5)

    kanidm.start()
    kanidm.wait_for_unit("kanidm.service")

    server.start()
    with subtest("server starting"):
      server.wait_for_unit("netbird-management.service")
      server.wait_for_unit("netbird-signal.service")
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

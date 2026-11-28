{
  pkgs,
  lib,
  nodes,
  ...
}:
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
      };
    };

    # no management server is reachable, so a login never succeeds;
    # the specialisations only check what `switch` starts or restarts
    switch = {
      services.netbird.clients.test = {
        port = 51818;
        environment.NB_MANAGEMENT_URL = "http://127.0.0.1:1";
      };

      specialisation.login.configuration = {
        services.netbird.clients.test.login = {
          enable = true;
          setupKeyFile = toString (pkgs.writeText "setup-key" "00000000-0000-0000-0000-000000000000");
        };
        # would otherwise keep `switch` waiting for the full timeout
        systemd.services.netbird-test-login.serviceConfig.TimeoutStartSec = lib.mkForce "5s";
      };

      specialisation.config.configuration = {
        services.netbird.clients.test.config.RosenpassEnabled = true;
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

    toplevel = "${nodes.switch.system.build.toplevel}"

    def switch_to(path):
      # the login cannot succeed, so the switch may report a failed unit
      switch.execute(f"{path}/bin/switch-to-configuration test")
      switch.wait_for_unit("netbird-test.service")

    def unit_property(unit, prop):
      return switch.succeed(f"systemctl show --value --property={prop} {unit}").strip()

    # switch only starts units wanted by targets that are already active
    switch.wait_for_unit("multi-user.target")
    switch.wait_for_unit("netbird-test.service")

    with subtest("switch starts a login enabled while the client runs"):
      assert unit_property("netbird-test-login.service", "ExecMainStartTimestampMonotonic") in ("", "0")
      switch_to(f"{toplevel}/specialisation/login")
      assert unit_property("netbird-test-login.service", "ExecMainStartTimestampMonotonic") not in ("", "0")

    with subtest("switch restarts the client when its config.d changes"):
      switch_to(toplevel)
      pid = unit_property("netbird-test.service", "MainPID")
      switch_to(f"{toplevel}/specialisation/config")
      assert unit_property("netbird-test.service", "MainPID") != pid
      switch.succeed("grep -q '\"RosenpassEnabled\": *true' /var/lib/netbird-test/config.json")
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

{ pkgs, ... }:
{
  name = "systemd-journal-gateway";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      minijackson
    ];
  };

  # Named client for coherence with the systemd-journal-upload test.
  nodes.client = {
    services.journald.gateway.enable = true;
  };

  testScript = ''
    import json

    client.wait_for_unit("multi-user.target")

    curl = '${pkgs.curl}/bin/curl'
    accept_json = '--header "Accept: application/json"'
    base_url = 'http://client:19531'

    curl_cli = f"{curl} {accept_json} --fail"

    machine_info = client.succeed(f"{curl_cli} {base_url}/machine")
    assert json.loads(machine_info)["hostname"] == "client", "wrong machine name"

    # The HTTP request should have started the gateway service, triggered by
    # the .socket unit
    client.wait_for_unit("systemd-journal-gatewayd.service")

    identifier = "nixos-test"
    message = "Hello from NixOS test infrastructure"

    client.succeed(f"systemd-cat --identifier={identifier} <<< '{message}'")

    entries = client.succeed(
        f"{curl_cli} {base_url}/entries?SYSLOG_IDENTIFIER={identifier}"
    )

    # Number of entries should be only 1
    added_entry = json.loads(entries)
    assert added_entry["SYSLOG_IDENTIFIER"] == identifier and added_entry["MESSAGE"] == message, "journal entry does not correspond"
  '';
}

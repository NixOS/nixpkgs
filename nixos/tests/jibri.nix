import ./make-test-python.nix ({ pkgs, ... }: {
  name = "jibri";
  meta = with pkgs.lib; {
    maintainers = teams.jitsi.members;
  };

    machine = { config, pkgs, ... }: {
      virtualisation.memorySize = 5120;

      services.jitsi-meet = {
        enable = true;
        hostName = "machine";
        jibri.enable = true;
      };
      services.jibri.ignoreCert = true;
      services.jitsi-videobridge.openFirewall = true;

      networking.firewall.allowedTCPPorts = [ 80 443 ];

      services.nginx.virtualHosts.machine = {
        enableACME = true;
        forceSSL = true;
      };

      security.acme.email = "me@example.org";
      security.acme.acceptTerms = true;
      security.acme.server = "https://example.com"; # self-signed only
    };

  testScript = ''
    machine.wait_for_unit("jitsi-videobridge2.service")
    machine.wait_for_unit("jicofo.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("prosody.service")
    machine.wait_for_unit("jibri.service")

    machine.wait_until_succeeds(
        "journalctl -b -u jitsi-videobridge2 -o cat | grep -q 'Performed a successful health check'", timeout=30
    )
    machine.wait_until_succeeds(
        "journalctl -b -u prosody -o cat | grep -q 'Authenticated as focus@auth.machine'", timeout=31
    )
    machine.wait_until_succeeds(
        "journalctl -b -u prosody -o cat | grep -q 'Authenticated as jvb@auth.machine'", timeout=32
    )
    machine.wait_until_succeeds(
        "journalctl -b -u prosody -o cat | grep -q 'Authenticated as jibri@auth.machine'", timeout=33
    )
    machine.wait_until_succeeds(
        "cat /var/log/jitsi/jibri/log.0.txt | grep -q 'Joined MUC: jibribrewery@internal.machine'", timeout=34
    )

    assert '"busyStatus":"IDLE","health":{"healthStatus":"HEALTHY"' in machine.succeed(
        "curl -X GET http://machine:2222/jibri/api/v1.0/health"
    )
    machine.succeed(
        """curl -H "Content-Type: application/json" -X POST http://localhost:2222/jibri/api/v1.0/startService -d '{"sessionId": "RecordTest","callParams":{"callUrlInfo":{"baseUrl": "https://machine","callName": "TestCall"}},"callLoginParams":{"domain": "recorder.machine", "username": "recorder", "password": "'"$(cat /var/lib/jitsi-meet/jibri-recorder-secret)"'" },"sinkType": "file"}'"""
    )
    machine.wait_until_succeeds(
        "cat /var/log/jitsi/jibri/log.0.txt | grep -q 'File recording service transitioning from state Starting up to Running'", timeout=35
    )
    machine.succeed(
        """sleep 15 && curl -H "Content-Type: application/json" -X POST http://localhost:2222/jibri/api/v1.0/stopService -d '{"sessionId": "RecordTest","callParams":{"callUrlInfo":{"baseUrl": "https://machine","callName": "TestCall"}},"callLoginParams":{"domain": "recorder.machine", "username": "recorder", "password": "'"$(cat /var/lib/jitsi-meet/jibri-recorder-secret)"'" },"sinkType": "file"}'"""
    )
    machine.wait_until_succeeds(
        "cat /var/log/jitsi/jibri/log.0.txt | grep -q 'Recording finalize script finished with exit value 0'", timeout=36
    )
  '';
})

{ pkgs, lib, ... }:

let
  apikey = "testapikey";
in
{
  name = "octoprint";
  meta.maintainers = with lib.maintainers; [ gador ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ jq ];
      services.octoprint = {
        enable = true;
        extraConfig = {
          server = {
            firstRun = false;
          };
          api = {
            enabled = true;
            key = apikey;
          };
          plugins = {
            # these need internet access and pollute the output with connection failed errors
            _disabled = [
              "softwareupdate"
              "announcements"
              "pluginmanager"
            ];
          };
        };
      };
    };

  testScript = ''
    import json

    @polling_condition
    def octoprint_running():
        machine.succeed("pgrep octoprint")

    with subtest("Wait for octoprint service to start"):
        machine.wait_for_unit("octoprint.service")
        machine.wait_until_succeeds("pgrep octoprint")

    with subtest("Wait for final boot"):
        # this appears whe octoprint is almost finished starting
        machine.wait_for_file("/var/lib/octoprint/uploads")

    # octoprint takes some time to start. This makes sure we'll retry just in case it takes longer
    # retry-all-errors in necessary, since octoprint will report a 404 error when not yet ready
    curl_cmd = "curl --retry-all-errors --connect-timeout 5 --max-time 10 --retry 5 --retry-delay 5 \
                --retry-max-time 40 -X GET --header 'X-API-Key: ${apikey}' "

    # used to fail early, in case octoprint first starts and then crashes
    with octoprint_running: # type: ignore[union-attr]
        with subtest("Check for web interface"):
            machine.wait_until_succeeds("curl -s localhost:5000")

        with subtest("Check API"):
            version = json.loads(machine.succeed(curl_cmd + "localhost:5000/api/version"))
            server = json.loads(machine.succeed(curl_cmd + "localhost:5000/api/server"))
            assert version["server"] == str("${pkgs.octoprint.version}")
            assert server["safemode"] == None
  '';
}

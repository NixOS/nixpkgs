{ pkgs, ... }:

{
  name = "gocron";
  meta.maintainers = with pkgs.lib.maintainers; [ juliusfreudenberger ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.jq ];
      services.gocron = {
        enable = true;
        settings = {
          jobs = [
            {
              name = "Test job";
              disabled_cron = true;
              commands = [
                "echo 'Job runs successfully'"
              ];
            }
          ];
        };
      };
    };

  testScript = ''
    def gocron_is_up(_) -> bool:
      status, _ = machine.execute("curl --fail http://localhost:8156")
      return status == 0

    def job_is_available() -> bool:
      status, output = machine.execute("curl http://localhost:8156/api/jobs | jq '. | length'")
      return status == 0 and int(output) == 1

    def start_job():
      machine.succeed("curl -X POST http://localhost:8156/api/jobs/Test%20job")

    def job_ran_successfully() -> bool:
      output = machine.succeed("curl http://localhost:8156/api/runs/Test%20job | jq '.[0].status_id, .[0].logs.[2].message'")
      split_output = output.split('\n')
      ran_successfully = int(split_output[0]) == 3
      log_message_as_expected = "Job runs not successfully" in split_output[1]
      return ran_successfully and log_message_as_expected

    machine.wait_for_unit("gocron.service")
    machine.wait_for_open_port(8156)
    with machine.nested("Waiting for UI to work"):
      retry(gocron_is_up)

    with machine.nested("Test job"):
      if not job_is_available():
        exit(1)
      start_job()
      if not job_ran_successfully():
        exit(1)
  '';
}

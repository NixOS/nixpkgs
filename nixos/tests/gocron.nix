{ pkgs, ... }:

{
  name = "gocron";
  meta.maintainers = with pkgs.lib.maintainers; [ juliusfreudenberger ];

  containers.machine = {
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
    import json

    STATUS_RUNNING = 1
    STATUS_SUCCESSFUL = 3

    def gocron_is_up(_) -> bool:
      status, _ = machine.execute("curl --fail http://localhost:8156")
      return status == 0

    def job_is_available() -> bool:
      output = machine.succeed("curl -s http://localhost:8156/api/jobs")
      return len(json.loads(output)) == 1

    def start_job():
      machine.succeed("curl -X POST http://localhost:8156/api/jobs/test-job")

    def get_last_run():
      output = machine.succeed("curl -s http://localhost:8156/api/runs/test-job")
      runs = json.loads(output)
      return runs[0] if runs else None

    def job_has_finished(_) -> bool:
      run = get_last_run()
      return run is not None and run["status_id"] != STATUS_RUNNING

    def job_ran_successfully() -> bool:
      run = get_last_run()
      ran_successfully = run["status_id"] == STATUS_SUCCESSFUL
      log_message_as_expected = "Job runs successfully" in run["logs"][2]["message"]
      return ran_successfully and log_message_as_expected

    machine.wait_for_unit("gocron.service")
    machine.wait_for_open_port(8156)
    with machine.nested("Waiting for UI to work"):
      retry(gocron_is_up)

    with machine.nested("Test job"):
      if not job_is_available():
        print("Cron job is not available")
        exit(1)
      start_job()
      retry(job_has_finished)
      if not job_ran_successfully():
        print("Cron job did not run successfully")
        exit(1)
  '';
}

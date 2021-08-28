import ./make-test-python.nix ({ pkgs, ...} : {
  name = "telegraf";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ mic92 ];
  };

  machine = { ... }: {
    services.telegraf.enable = true;
    services.telegraf.environmentFiles = [(pkgs.writeText "secrets" ''
      SECRET=example
    '')];
    services.telegraf.extraConfig = {
      agent.interval = "1s";
      agent.flush_interval = "1s";
      inputs.exec = {
        commands = [
          "${pkgs.runtimeShell} -c 'echo $SECRET,tag=a i=42i'"
        ];
        timeout = "5s";
        data_format = "influx";
      };
      outputs.file.files = ["/tmp/metrics.out"];
      outputs.file.data_format = "influx";
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("telegraf.service")
    machine.wait_until_succeeds("grep -q example /tmp/metrics.out")
  '';
})

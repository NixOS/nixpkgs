{
  name = "auto-cpufreq-server";

  nodes = {
    machine = {
      # service will still start but since vm inside qemu cpufreq adjustments
      # cannot be made. This will resource in the following error but the service
      # remains up:
      #   ERROR:
      #   Couldn't find any of the necessary scaling governors.
      services.auto-cpufreq = {
        enable = true;
        settings = {
          charger = {
            turbo = "auto";
          };
        };
      };
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("auto-cpufreq.service")
    machine.succeed("auto-cpufreq --force reset")
  '';
}

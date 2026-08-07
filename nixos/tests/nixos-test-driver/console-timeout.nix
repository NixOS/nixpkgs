{ pkgs, lib, ... }:
{
  name = "console-timeout";

  nodes.machine = {
    systemd.services.generate-output.script = ''
      echo "match that"
      sleep 1

      for i in $(seq 15); do
        echo "line $i"
      done

      echo "match this"
    '';
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    machine.systemctl("start generate-output")
    machine.wait_for_console_text("match that")
    machine.wait_for_console_text("match this", timeout=10)
  '';
}

{ lib, ... }:

{
  name = "gotenberg";

  nodes.machine = {
    services.gotenberg = {
      enable = true;
      # fail the service if any of those does not come up
      chromium.autoStart = true;
      libreoffice.autoStart = true;
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("gotenberg.service")

    # Gotenberg startup
    machine.wait_for_open_port(3000)

    # Ensure healthcheck endpoint succeeds
    machine.succeed("curl http://localhost:3000/health")

    # Convert a document through LibreOffice.
    machine.succeed("echo hello > /tmp/test.txt")
    machine.succeed(
        "curl -sf -F files=@/tmp/test.txt"
        " -o /tmp/test.pdf http://localhost:3000/forms/libreoffice/convert"
    )
    machine.succeed("head -c 4 /tmp/test.pdf | grep -q '%PDF'")
  '';
}

{ lib, ... }:

{
  name = "jirafeau";
  meta.maintainers = [ ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.jirafeau = {
        enable = true;
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("phpfpm-jirafeau.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl -sSfL http://localhost/ | grep 'Jirafeau'")

    machine.succeed("printf '%s' '<svg xmlns=\"http://www.w3.org/2000/svg\"><script>alert(1)</script></svg>' > /tmp/preview.svg")
    link = machine.succeed(
        "curl --fail --silent --show-error "
        "-F time=month -F 'file=@/tmp/preview.svg;type=image' "
        "http://localhost/script.php"
    ).splitlines()[0]
    headers = machine.succeed(
        f"curl --fail --silent --show-error --dump-header - "
        f"--output /tmp/preview-response 'http://localhost/f.php?h={link}&p=1'"
    )
    header_lines = {line.lower() for line in headers.splitlines()}
    assert "x-content-type-options: nosniff" in header_lines
    assert "content-type: image" in header_lines
    machine.succeed("cmp /tmp/preview.svg /tmp/preview-response")
  '';
}

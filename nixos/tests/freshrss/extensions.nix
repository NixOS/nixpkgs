{
  name = "freshrss-extensions";

  nodes.machine =
    { pkgs, ... }:
    {
      services.freshrss = {
        enable = true;
        baseUrl = "http://localhost";
        authType = "none";
        extensions = [ pkgs.freshrss-extensions.youtube ];
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_open_port(80)
    response = machine.succeed("curl -vvv -s http://localhost:80/i/?c=extension")
    assert '<span class="ext_name disabled">YouTube Video Feed</span>' in response, "Extension not present in extensions page."
  '';
}

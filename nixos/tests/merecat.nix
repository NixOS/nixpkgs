{ pkgs, ... }:
{
  name = "merecat";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fgaz ];
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.merecat = {
        enable = true;
        settings = {
          hostname = "localhost";
          virtual-host = true;
          directory = toString (
            pkgs.runCommand "merecat-webdir" { } ''
              mkdir -p $out/foo.localhost $out/bar.localhost
              echo '<h1>Hello foo</h1>' > $out/foo.localhost/index.html
              echo '<h1>Hello bar</h1>' > $out/bar.localhost/index.html
            ''
          );
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("merecat")
    machine.wait_for_open_port(80)
    machine.succeed("curl --fail foo.localhost | grep 'Hello foo'")
    machine.succeed("curl --fail bar.localhost | grep 'Hello bar'")
  '';
}

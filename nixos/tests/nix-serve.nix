{ config, ... }:
{
  name = "nix-serve";
  nodes.machine =
    { pkgs, ... }:
    {
      services.nix-serve.enable = true;
      environment.systemPackages = [
        pkgs.hello
      ];
      nix.enable = true; # disabled by default. See all-tests.nix / tag(no-nix-by-default)
    };
  testScript =
    let
      pkgHash = builtins.head (
        builtins.match "${builtins.storeDir}/([^-]+).+" (toString config.node.pkgs.hello)
      );
    in
    ''
      start_all()
      machine.wait_for_unit("nix-serve.service")
      machine.wait_for_open_port(5000)
      machine.succeed(
          "curl --fail -g http://0.0.0.0:5000/nar/${pkgHash}.nar -o /tmp/hello.nar"
      )
    '';
}

let
  pkgs = import ../. { };
  inherit (pkgs.testers) runNixOSTest;
in

runNixOSTest {
  name = "abstract-service";

  nodes.machine = { lib, options, ... }: {
    imports = [
      ./configuration.nix
    ];

    # Ignore this. It makes nodes.machine.options appear in
    # nix repl -f example/nixos-test.nix
    options.options = lib.mkOption { default = options; };
  };

  testScript = ''
    machine.wait_for_open_port(8080);
  '';
}

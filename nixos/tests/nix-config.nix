{ pkgs, ... }:
{
  name = "nix-config";
  nodes.machine =
    { pkgs, ... }:
    {
      nix.settings = {
        nix-path = [ "nonextra=/etc/value.nix" ];
        extra-nix-path = [ "extra=/etc/value.nix" ];
      };
      environment.etc."value.nix".text = "42";
    };
  testScript = ''
    start_all()
    machine.wait_for_unit("nix-daemon.socket")
    # regression test for the workaround for https://github.com/NixOS/nix/issues/9487
    # unset NIX_PATH because environtment overrides the config
    print(machine.succeed("env -u NIX_PATH nix-instantiate --find-file extra"))
    print(machine.succeed("env -u NIX_PATH nix-instantiate --find-file nonextra"))
  '';
}

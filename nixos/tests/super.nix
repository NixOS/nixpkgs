{ pkgs, lib, ... }:
{
  name = "super";
  meta = with lib.maintainers; {
    maintainers = [ hythera ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.super ];
    };
  testScript = ''
    machine.start()

    data = machine.succeed("echo '\"hello, world\"' | super -color=false -f=line -")

    assert data == "hello, world\n"
  '';
}

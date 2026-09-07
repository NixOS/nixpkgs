{ pkgs, ... }:

let
  hello-world = ./files/HelloWorld.agda;
in
{
  name = "agda";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      alexarice
      turion
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.agda.withPackages {
          pkgs = p: [ p.standard-library ];
        })
      ];
      virtualisation.memorySize = 2000; # Agda uses a lot of memory
    };

  testScript = ''
    # agda and agda-mode are in path
    machine.succeed("agda --version")

    # Minimal script that typechecks
    machine.succeed("touch TestEmpty.agda")
    machine.succeed("agda TestEmpty.agda")

    # Hello world
    machine.succeed(
        "cp ${hello-world} HelloWorld.agda"
    )
    machine.succeed("agda -l standard-library -i . -c HelloWorld.agda")
    # Check execution
    assert "Hello World!" in machine.succeed(
        "./HelloWorld"
    ), "HelloWorld does not run properly"
  '';
}

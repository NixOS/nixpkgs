import ./make-test-python.nix ({ pkgs, ... }:

let
  hello-world = pkgs.writeText "hello-world" ''
    open import IO

    main = run(putStrLn "Hello World!")
  '';
in
{
  name = "agda";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ alexarice turion ];
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.agda.withPackages {
        pkgs = p: [ p.standard-library ];
      })
    ];
    virtualisation.memorySize = 2000; # Agda uses a lot of memory
  };

  testScript = ''
    # Minimal script that typechecks
    machine.succeed("touch TestEmpty.agda")
    machine.succeed("agda TestEmpty.agda")

    # Minimal script that actually uses the standard library
    machine.succeed('echo "import IO" > TestIO.agda')
    machine.succeed("agda -l standard-library -i . TestIO.agda")

    # # Hello world
    machine.succeed(
        "cp ${hello-world} HelloWorld.agda"
    )
    machine.succeed("agda -l standard-library -i . -c HelloWorld.agda")
  '';
}
)

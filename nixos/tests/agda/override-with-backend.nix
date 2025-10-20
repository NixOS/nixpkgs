{ pkgs, ... }:
let
  mainProgram = "agda-trivial-backend";

  hello-world = pkgs.writeText "hello-world" ''
    {-# OPTIONS --guardedness #-}
    open import IO
    open import Level

    main = run {0ℓ} (putStrLn "Hello World!")
  '';
  agda-trivial-backend =
    pkgs.runCommand "trivial-backend"
      {
        version = "${pkgs.haskellPackages.Agda.version}";
        meta.mainProgram = "${mainProgram}";
        buildInputs = [ (pkgs.haskellPackages.ghcWithPackages (pkgs: [ pkgs.Agda ])) ];
      }
      ''
        cat << EOF > Main.hs
        module Main where

        import Agda.Main ( runAgda )

        main :: IO ()
        main = runAgda []
        EOF

        ghc Main.hs -o ${mainProgram}
        mkdir -p $out/bin
        cp ${mainProgram} $out/bin
      '';
in
{
  name = "agda-trivial-backend";
  meta = {
    maintainers = [
      # FIXME
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    let
      agdaPackages = pkgs.agdaPackages.override (oldAttrs: {
        Agda = agda-trivial-backend;
      });
    in
    {
      environment.systemPackages = [
        (agdaPackages.agda.withPackages {
          pkgs = p: [ p.standard-library ];
        })
      ];
      virtualisation.memorySize = 2000; # Agda uses a lot of memory
    };

  testScript = ''
    # agda executable is not present
    machine.fail("agda --version")
    # Hello world
    machine.succeed(
        "cp ${hello-world} HelloWorld.agda"
    )
    machine.succeed("${mainProgram} -l standard-library -i . -c HelloWorld.agda")
    # Check execution
    assert "Hello World!" in machine.succeed(
        "./HelloWorld"
    ), "HelloWorld does not run properly"
  '';
}

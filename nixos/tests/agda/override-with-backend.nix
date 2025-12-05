{ pkgs, ... }:
let
  mainProgram = "agda-trivial-backend";

  hello-world = ./files/HelloWorld.agda;

  agda-trivial-backend = pkgs.stdenvNoCC.mkDerivation {
    name = "trivial-backend";
    meta = { inherit mainProgram; };
    version = "${pkgs.haskellPackages.Agda.version}";
    src = ./files/TrivialBackend.hs;
    buildInputs = [
      (pkgs.haskellPackages.ghcWithPackages (pkgs: [ pkgs.Agda ]))
    ];
    dontUnpack = true;
    buildPhase = ''
      ghc $src -o ${mainProgram}
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp ${mainProgram} $out/bin
    '';
  };
in
{
  name = "agda-trivial-backend";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      carlostome
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
    # agda and agda-mode are not in path
    machine.fail("agda --version")
    machine.fail("agda-mode")
    # backend is present
    text = machine.succeed("${mainProgram} --help")
    assert "${mainProgram}" in text
    # Hello world
    machine.succeed(
        "cp ${hello-world} HelloWorld.agda"
    )
    machine.succeed("${mainProgram} -l standard-library -i . -c HelloWorld.agda")
    # Check execution
    text = machine.succeed("./HelloWorld")
    assert "Hello World!" in text, f"HelloWorld does not run properly: output was {text}"
  '';
}

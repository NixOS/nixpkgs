import ./make-test-python.nix ({ pkgs, ...} : {
  name = "sbt";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.sbt ];
    };

  testScript =
    ''
      machine.succeed(
          "(sbt --offline --version 2>&1 || true) | grep 'getting org.scala-sbt sbt ${pkgs.sbt.version}  (this may take some time)'"
      )
    '';
})

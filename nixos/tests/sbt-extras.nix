import ./make-test-python.nix ({ pkgs, ...} : {
  name = "sbt-extras";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.sbt-extras ];
    };

  testScript =
    ''
      machine.succeed("(sbt -h)")
    '';
})

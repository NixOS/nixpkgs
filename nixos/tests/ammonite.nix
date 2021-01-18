import ./make-test-python.nix ({ pkgs, ...} : {
  name = "ammonite";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  nodes = {
    amm =
      { pkgs, ... }:
        {
          environment.systemPackages = [ (pkgs.ammonite.override { jre = pkgs.jre8; }) ];
        };
    };

  testScript = ''
    start_all()

    amm.succeed("amm -c 'val foo = 21; println(foo * 2)' | grep 42")
  '';
})

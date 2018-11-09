import ./make-test.nix ({ pkgs, ...} : {
  name = "ammonite";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
    timeout = 40;
  };

  nodes = {
    amm =
      { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.ammonite ];
        };
    };

  testScript = ''
    startAll;

    $amm->succeed("amm -c 'val foo = 21; println(foo * 2)' | grep 42")
  '';
})

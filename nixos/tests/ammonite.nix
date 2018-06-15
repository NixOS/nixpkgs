import ./make-test.nix ({ pkgs, ...} : {
  name = "ammonite";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  nodes = {
    amm =
      { config, pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.ammonite ];
        };
    };

  testScript = ''
    startAll;

    $amm->succeed("amm -c 'val foo = 21; println(foo * 2)' | grep 42")
  '';
})

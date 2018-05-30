import ./make-test.nix ({ pkgs, ... }:

{
  name = "morty";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ leenaars ];
  };

  nodes =
    { mortyProxyWithKey =

      { config, pkgs, ... }:
      { services.morty = {
        enable = true;
	key = "78a9cd0cfee20c672f78427efb2a2a96036027f0";
	port = 3001;
	};
      };

    };

  testScript =
    { nodes , ... }:
    ''
      startAll;

      $mortyProxyWithKey->waitForUnit("morty");
      $mortyProxyWithKey->succeed("curl -L 127.0.0.1:3001 | grep MortyProxy");

    '';

})

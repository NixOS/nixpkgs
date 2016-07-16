import ./make-test.nix (
    { pkgs, ... } : {
        name = "dunst";
        meta = with pkgs.stdenv.lib.maintainers; {
            maintainers = [ matthiasbeyer ];
        };

        nodes = {
            dunst = { config, pkgs, ... }: {
                services.xserver.enable = true;
                services.dunst.enable   = true;
                environment.systemPackages = [ pkgs.libnotify ];
            };
        };

        testScript = ''
            startAll;

            $dunst->execute("echo Waiting for dunst now");
            $dunst->waitForUnit("dunst.service");

            $dunst->succeed("notify-send 'HelloWorld'");
        '';
    }
)

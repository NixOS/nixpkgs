import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "graphics-gbm";
    meta = {
      maintainers = [ lib.maintainers.lucasew ];
    };
    nodes = {
      battlestation =
        { config, ... }:
        {
          hardware.graphics.enable = true;
        };
    };

    testScript = ''
      start_all()
      battlestation.wait_for_unit('multi-user.target')
      battlestation.succeed('[ -e /run/opengl-driver/lib/gbm/dri_gbm.so ]')
    '';
  }
)

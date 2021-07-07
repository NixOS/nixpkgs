import ./make-test-python.nix ( { pkgs, ... }: {
  name = "redshift";
  meta = {
    maintainers = with pkgs.stdenv.lib.maintainers; [ thiagokokada ];
  };

  machine = { pkgs, ... }:
    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];
      test-support.displayManager.auto.user = "alice";

      location = {
        provider = "manual";
        latitude = 0.0;
        longitude = 0.0;
      };

      services.redshift = {
        enable = true;
        settings = {
          redshift = {
            temp-day = 1500;
            temp-night = 1500;
            gamma = 0.8;
            fade = 0;
          };
        };
      };
    };

  testScript =
    ''
      machine.start()
      machine.wait_for_x()
      machine.wait_for_unit("redshift.service", "alice")
    '';
})

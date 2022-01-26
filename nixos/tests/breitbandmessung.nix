import ./make-test-python.nix ({ lib, ... }: {
  name = "breitbandmessung";
  meta.maintainers = with lib.maintainers; [ b4dm4n ];

  machine = { pkgs, ... }: {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    test-support.displayManager.auto.user = "alice";

    environment.systemPackages = with pkgs; [ breitbandmessung ];
    environment.variables.XAUTHORITY = "/home/alice/.Xauthority";

    # breitbandmessung is unfree
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "breitbandmessung" ];
  };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()
    # increase screen size to make the whole program visible
    machine.succeed("xrandr --output Virtual-1 --mode 1280x1024")
    machine.execute("su - alice -c breitbandmessung >&2  &")
    machine.wait_for_window("Breitbandmessung")
    machine.wait_for_text("Breitbandmessung")
    machine.wait_for_text("Datenschutz")
    machine.screenshot("breitbandmessung")
  '';
})

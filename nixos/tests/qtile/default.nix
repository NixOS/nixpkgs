import ../make-test-python.nix ({ lib, ...} : {
  name = "qtile";

  meta = {
    maintainers = with lib.maintainers; [ sigmanificient ];
  };

  nodes.machine = { pkgs, lib, ... }: let
    # We create a custom Qtile configuration file that adds a widget from
    # qtile-extras to the bar. This ensure that the qtile-extras package
    # also works, and that extraPackages behave as expected.

    config = { stdenvNoCC, fetchurl }:
      stdenvNoCC.mkDerivation {
        name = "qtile-config";
        version = "0.0.1";

        src = fetchurl {
          url = "https://raw.githubusercontent.com/qtile/qtile/master/libqtile/resources/default_config.py";
          hash = "sha256-Y5W277CWVNSi4BdgEW/f7Px/MMjnN9W9TDqdOncVwPc=";
        };

        prePatch = ''
          cp $src config.py
        '';

        patches = [ ./add-widget.patch ];

        dontUnpack = true;
        dontBuild = true;

        installPhase = ''
          mkdir -p $out
          cp config.py $out/config.py
        '';
      };
  in {
    imports = [ ../common/x11.nix ../common/user-account.nix ];
    test-support.displayManager.auto.user = "alice";

    services.xserver.windowManager.qtile = let
      config-deriv = pkgs.callPackage config { };
    in {
      enable = true;
      configFile = "${config-deriv}/config.py";
      extraPackages = ps: [ ps.qtile-extras ];
    };

    services.displayManager.defaultSession = lib.mkForce "qtile";

    environment.systemPackages = [ pkgs.kitty ];
  };

  testScript = ''
    with subtest("ensure x starts"):
        machine.wait_for_x()
        machine.wait_for_file("/home/alice/.Xauthority")
        machine.succeed("xauth merge ~alice/.Xauthority")

    with subtest("ensure client is available"):
        machine.succeed("qtile --version")

    with subtest("ensure we can open a new terminal"):
        machine.sleep(2)
        machine.send_key("meta_l-ret")
        machine.wait_for_window(r"alice.*?machine")
        machine.sleep(2)
        machine.screenshot("terminal")
  '';
})

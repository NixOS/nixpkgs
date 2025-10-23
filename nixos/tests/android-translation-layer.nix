{ pkgs, lib, ... }:
let
  # Example Android app
  demoApp = pkgs.fetchurl {
    url = "https://gitlab.com/android_translation_layer/atl_test_apks/-/raw/061e32a3172c8167b1746768d098f0e62d8f564b/demo_app.apk";
    hash = "sha256-aXxLZEAMNsL6nL4r2N9rVsbBPmf3+gFGmgo3kZjdo4s=";
  };
in
{
  name = "android-translation-layer";
  meta.maintainers = with pkgs.lib.maintainers; [ onny ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [
        ./common/x11.nix
      ];

      services.xserver.enable = true;

      environment = {
        systemPackages = [ pkgs.android-translation-layer ];
      };
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()

    with subtest("launch android translation layer demo app"):
        machine.succeed("android-translation-layer ${demoApp} >&2 &")
        machine.sleep(10)
        machine.wait_for_text(r"hello PoC world!")
        machine.screenshot("atl_demo_app")

    machine.succeed("pkill -f android-translation-layer")
  '';
}
